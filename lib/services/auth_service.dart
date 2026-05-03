import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get user stream
  Stream<User?> get user => _auth.authStateChanges();

  // Get user profile stream from Firestore
  Stream<UserProgress> getUserProfile(User user) {
    final String docId = user.displayName ?? user.email?.split('@')[0] ?? user.uid;

    return _db.collection('users').doc(docId).snapshots().asyncMap((snapshot) async {
      if (snapshot.exists) {
        return UserProgress.fromMap(snapshot.data() as Map<String, dynamic>);
      }

      // Fallback: search by uid field
      final query = await _db
          .collection('users')
          .where('uid', isEqualTo: user.uid)
          .limit(1)
          .get();
      if (query.docs.isNotEmpty) {
        return UserProgress.fromMap(query.docs.first.data());
      }

      // Secondary fallback: return default so the UI never crashes
      return sampleUserProgress.copyWith(
        name: user.displayName ?? user.email?.split('@')[0] ?? 'Artist',
        avatarUrl: user.photoURL ?? 'https://i.pravatar.cc/150?u=${user.uid}',
      );
    });
  }

  // Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    UserCredential result = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    User? user = result.user;
    if (user != null) {
      final String name = user.displayName ?? email.split('@')[0];
      final DocumentSnapshot doc =
          await _db.collection('users').doc(name).get();
      if (!doc.exists) {
        await _createUserProfile(user, email, name);
      }
    }

    return result;
  }

  // Sign up with email and password
  Future<UserCredential?> signUp(
    String email,
    String password,
    String name,
  ) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    User? user = result.user;
    if (user != null) {
      await _createUserProfile(user, email, name);
    }
    return result;
  }

  // Helper to create user profile in Firestore
  Future<void> _createUserProfile(User user, String email, String name) async {
    final String docId = name;
    await user.updateDisplayName(name);
    await _db.collection('users').doc(docId).set({
      'uid': user.uid,
      'docId': docId,
      'email': email,
      'name': name,
      'avatarUrl': user.photoURL ?? 'https://i.pravatar.cc/150?u=${user.uid}',
      'currentXP': 0,
      'currentLevel': 1,
      'streakDays': 0,
      'totalLessonsCompleted': 0,
      'achievements': [],
      'recentlyCompleted': [],
      'completedDates': {},
      'lastActive': FieldValue.serverTimestamp(),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
