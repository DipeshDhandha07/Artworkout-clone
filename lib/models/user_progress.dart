import 'package:cloud_firestore/cloud_firestore.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final bool isUnlocked;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'icon': icon,
    'isUnlocked': isUnlocked,
  };

  factory Achievement.fromMap(Map<String, dynamic> map) => Achievement(
    id: map['id'] ?? '',
    title: map['title'] ?? '',
    description: map['description'] ?? '',
    icon: map['icon'] ?? '🏅',
    isUnlocked: map['isUnlocked'] ?? false,
  );
}

class CompletedLesson {
  final String lessonId;
  final String lessonTitle;
  final DateTime completionDate;
  final int xpEarned;

  const CompletedLesson({
    required this.lessonId,
    required this.lessonTitle,
    required this.completionDate,
    required this.xpEarned,
  });

  Map<String, dynamic> toMap() => {
    'lessonId': lessonId,
    'lessonTitle': lessonTitle,
    'completionDate': completionDate.toIso8601String(),
    'xpEarned': xpEarned,
  };

  factory CompletedLesson.fromMap(Map<String, dynamic> map) {
    // Safely handle both Firestore Timestamp and ISO String
    DateTime date;
    final raw = map['completionDate'];
    if (raw is Timestamp) {
      date = raw.toDate();
    } else if (raw is String) {
      date = DateTime.tryParse(raw) ?? DateTime.now();
    } else {
      date = DateTime.now();
    }
    return CompletedLesson(
      lessonId: map['lessonId'] ?? '',
      lessonTitle: map['lessonTitle'] ?? '',
      completionDate: date,
      xpEarned: map['xpEarned'] ?? 0,
    );
  }
}

class UserProgress {
  final String name;
  final String avatarUrl;
  final int currentXP;
  final int currentLevel;
  final int streakDays;
  final int totalLessonsCompleted;
  final List<Achievement> achievements;
  final List<CompletedLesson> recentlyCompleted;
  final Map<String, bool> completedDates;

  const UserProgress({
    required this.name,
    required this.avatarUrl,
    required this.currentXP,
    required this.currentLevel,
    required this.streakDays,
    required this.totalLessonsCompleted,
    required this.achievements,
    required this.recentlyCompleted,
    required this.completedDates,
  });

  int get nextLevelXP => (currentLevel + 1) * 500;

  /// Guard against division by zero if nextLevelXP is ever 0
  double get levelProgress {
    final threshold = nextLevelXP;
    if (threshold <= 0) return 0.0;
    // XP resets per level: progress within current level
    final xpIntoLevel = currentXP % 500;
    return (xpIntoLevel / 500).clamp(0.0, 1.0);
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'avatarUrl': avatarUrl,
    'currentXP': currentXP,
    'currentLevel': currentLevel,
    'streakDays': streakDays,
    'totalLessonsCompleted': totalLessonsCompleted,
    'achievements': achievements.map((a) => a.toMap()).toList(),
    'recentlyCompleted': recentlyCompleted.map((c) => c.toMap()).toList(),
    'completedDates': completedDates,
  };

  UserProgress copyWith({
    String? name,
    String? avatarUrl,
    int? currentXP,
    int? currentLevel,
    int? streakDays,
    int? totalLessonsCompleted,
    List<Achievement>? achievements,
    List<CompletedLesson>? recentlyCompleted,
    Map<String, bool>? completedDates,
  }) {
    return UserProgress(
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentXP: currentXP ?? this.currentXP,
      currentLevel: currentLevel ?? this.currentLevel,
      streakDays: streakDays ?? this.streakDays,
      totalLessonsCompleted: totalLessonsCompleted ?? this.totalLessonsCompleted,
      achievements: achievements ?? this.achievements,
      recentlyCompleted: recentlyCompleted ?? this.recentlyCompleted,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  factory UserProgress.fromMap(Map<String, dynamic> map) => UserProgress(
    name: map['name'] ?? '',
    avatarUrl: map['avatarUrl'] ?? '',
    currentXP: map['currentXP'] ?? 0,
    currentLevel: (map['currentLevel'] ?? 1).clamp(1, 9999),
    streakDays: map['streakDays'] ?? 0,
    totalLessonsCompleted: map['totalLessonsCompleted'] ?? 0,
    achievements: (map['achievements'] as List?)
            ?.map((a) => Achievement.fromMap(a as Map<String, dynamic>))
            .toList() ??
        [],
    recentlyCompleted: (map['recentlyCompleted'] as List?)
            ?.map((c) => CompletedLesson.fromMap(c as Map<String, dynamic>))
            .toList() ??
        [],
    // Only store true-valued dates; filter out false values
    completedDates: Map<String, bool>.from(map['completedDates'] ?? {})
      ..removeWhere((key, value) => value == false),
  );
}

// ─── ArtWorkout Sample Progress ──────────────────────────────────────────────

final UserProgress sampleUserProgress = UserProgress(
  name: 'Alex Drafter',
  avatarUrl: 'https://i.pravatar.cc/150?u=alex',
  currentXP: 340,
  currentLevel: 5,
  streakDays: 12,
  totalLessonsCompleted: 45,
  // Only true-completed dates
  completedDates: {
    '2026-05-02': true,
    '2026-05-01': true,
    '2026-04-30': true,
    '2026-04-29': true,
    '2026-04-28': true,
    '2026-04-27': true,
    '2026-04-25': true,
  },
  achievements: [
    const Achievement(
      id: 'early-bird',
      title: 'Early Bird',
      description: 'Completed a lesson before 8 AM',
      icon: '🌅',
      isUnlocked: true,
    ),
    const Achievement(
      id: 'streak-10',
      title: 'Double Digits',
      description: 'Reached a 10-day streak',
      icon: '🔥',
      isUnlocked: true,
    ),
    const Achievement(
      id: 'character-master',
      title: 'Character Pro',
      description: 'Completed 10 Character lessons',
      icon: '🥷',
      isUnlocked: false,
    ),
  ],
  recentlyCompleted: [
    CompletedLesson(
      lessonId: 'cute-bunny',
      lessonTitle: 'Cute Bunny',
      completionDate: DateTime.now().subtract(const Duration(hours: 2)),
      xpEarned: 30,
    ),
    CompletedLesson(
      lessonId: 'delicious-pizza',
      lessonTitle: 'Pepperoni Pizza',
      completionDate: DateTime.now().subtract(const Duration(days: 1)),
      xpEarned: 60,
    ),
  ],
);
