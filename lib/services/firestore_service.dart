import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/lesson.dart';
import '../models/user_progress.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User? get _user => FirebaseAuth.instance.currentUser;
  
  String get docId {
    final user = _user;
    if (user == null) return 'unknown';
    // Match the AuthService logic exactly: use display name or the name part of the email
    return user.displayName ?? user.email?.split('@')[0] ?? user.uid;
  }

  // Get user progress stream
  Stream<UserProgress> get userProgressStream {
    return _db.collection('users').doc(docId).snapshots().map((doc) {
      if (doc.exists) {
        return UserProgress.fromMap(doc.data() as Map<String, dynamic>);
      }
      return sampleUserProgress; // Fallback to sample if no data yet
    });
  }

  // Update user progress
  Future<void> saveUserProgress(UserProgress progress) async {
    await _db.collection('users').doc(docId).set(progress.toMap(), SetOptions(merge: true));
  }

  // Record lesson completion
  Future<void> completeLesson(Lesson lesson) async {
    final now = DateTime.now();
    final dateKey = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    
    // Get current data to calculate level and streak
    final doc = await _db.collection('users').doc(docId).get();
    
    Map<String, dynamic> data = {};
    if (doc.exists) {
      data = doc.data() as Map<String, dynamic>;
    }
    int currentXP = data['currentXP'] ?? 0;
    Map<String, dynamic> completedDates = data['completedDates'] ?? {};
    
    // Update XP
    int newXP = currentXP + lesson.xpReward;
    int newLevel = (newXP ~/ 500) + 1; // 500 XP per level

    // Streak logic
    int streakDays = data['streakDays'] ?? 0;
    final yesterday = now.subtract(const Duration(days: 1));
    final yesterdayKey = "${yesterday.year}-${yesterday.month.toString().padLeft(2, '0')}-${yesterday.day.toString().padLeft(2, '0')}";
    
    if (completedDates.containsKey(yesterdayKey)) {
      if (!completedDates.containsKey(dateKey)) {
        streakDays++;
      }
    } else if (!completedDates.containsKey(dateKey)) {
      streakDays = 1; // Start new streak
    }
    
    await _db.collection('users').doc(docId).set({
      'currentXP': newXP,
      'currentLevel': newLevel,
      'streakDays': streakDays,
      'totalLessonsCompleted': FieldValue.increment(1),
      'completedDates.$dateKey': true,
      'recentlyCompleted': FieldValue.arrayUnion([{
        'lessonId': lesson.id,
        'lessonTitle': lesson.title,
        'completionDate': now.toIso8601String(),
        'xpEarned': lesson.xpReward,
      }]),
      'lastActive': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

}
