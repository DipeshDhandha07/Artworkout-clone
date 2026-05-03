class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final String badgeName;
  final int timeRemainingHours;
  final int participantCount;
  final List<String> requiredTechniques;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.badgeName,
    required this.timeRemainingHours,
    required this.participantCount,
    required this.requiredTechniques,
  });
}

class GalleryEntry {
  final String id;
  final String artistName;
  final String timeAgo;
  final int likes;
  final String gradientStart;
  final String gradientEnd;
  final String artTitle;

  const GalleryEntry({
    required this.id,
    required this.artistName,
    required this.timeAgo,
    required this.likes,
    required this.gradientStart,
    required this.gradientEnd,
    required this.artTitle,
  });
}

// ─── Sample Data ─────────────────────────────────────────────────────────────

const DailyChallenge todaysChallenge = DailyChallenge(
  id: 'natural-textures-light',
  title: 'Mastering Natural Textures & Light',
  description:
      'Capture the porous texture of a lemon skin and the translucent glow of a sliced orange using layering techniques.',
  badgeName: 'Studio Elite Badge',
  timeRemainingHours: 8,
  participantCount: 247,
  requiredTechniques: ['Layering', 'Glazing', 'Wet-on-Wet', 'Texture'],
);

const List<GalleryEntry> communityGallery = [
  GalleryEntry(
    id: 'entry-1',
    artistName: 'Elena Rossi',
    timeAgo: '2 hours ago',
    likes: 48,
    gradientStart: '#7C3AED',
    gradientEnd: '#2170E4',
    artTitle: 'Morning Citrus',
  ),
  GalleryEntry(
    id: 'entry-2',
    artistName: 'Marcus Thorne',
    timeAgo: '5 hours ago',
    likes: 31,
    gradientStart: '#0058BE',
    gradientEnd: '#9B005C',
    artTitle: 'Translucent Orange',
  ),
  GalleryEntry(
    id: 'entry-3',
    artistName: 'Sarah Jenkins',
    timeAgo: 'Yesterday',
    likes: 67,
    gradientStart: '#BF2076',
    gradientEnd: '#630ED4',
    artTitle: 'Lemon Study No.3',
  ),
  GalleryEntry(
    id: 'entry-4',
    artistName: 'Kai Tanaka',
    timeAgo: '2 days ago',
    likes: 22,
    gradientStart: '#2170E4',
    gradientEnd: '#7C3AED',
    artTitle: 'Zesty Still Life',
  ),
  GalleryEntry(
    id: 'entry-5',
    artistName: 'Priya Sharma',
    timeAgo: '2 days ago',
    likes: 55,
    gradientStart: '#630ED4',
    gradientEnd: '#BF2076',
    artTitle: 'Light Through Peel',
  ),
];
