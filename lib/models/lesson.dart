enum LessonType {
  trace,
  sketch,
  color,
  theory,
}

class LessonStep {
  final String title;
  final String description;
  final String? templateUrl;
  final bool isCompleted;

  const LessonStep({
    required this.title,
    required this.description,
    this.templateUrl,
    this.isCompleted = false,
  });
}

class Lesson {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String difficulty;
  final int durationMinutes;
  final int xpReward;
  final bool isPremium;
  final String thumbnailUrl;
  final List<LessonStep> steps;
  final LessonType type;

  const Lesson({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.difficulty,
    this.durationMinutes = 5,
    this.xpReward = 50,
    this.isPremium = false,
    required this.thumbnailUrl,
    this.steps = const [],
    this.type = LessonType.trace,
  });
}

class LessonCategory {
  final String id;
  final String label;
  final List<Lesson> lessons;

  const LessonCategory({
    required this.id,
    required this.label,
    required this.lessons,
  });
}

// ─── ArtWorkout Sample Data ──────────────────────────────────────────────────

final List<Lesson> sampleLessons = [
  const Lesson(
    id: 'cute-bunny',
    title: 'Cute Bunny',
    subtitle: 'Learn to draw a simple and adorable bunny step-by-step.',
    category: 'Animals',
    difficulty: 'Beginner',
    durationMinutes: 5,
    xpReward: 30,
    isPremium: false,
    thumbnailUrl: 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=400&q=80',
    type: LessonType.trace,
    steps: [
      LessonStep(
        title: 'Head Outline',
        description: 'Draw a soft oval for the head.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253113.png',
      ),
      LessonStep(
        title: 'Floppy Ears',
        description: 'Add two long ears on top.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/2619/2619213.png',
      ),
      LessonStep(
        title: 'Face Details',
        description: 'Draw the eyes, nose, and whiskers.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253134.png',
      ),
    ],
  ),
  const Lesson(
    id: 'cool-samurai',
    title: 'Neon Samurai',
    subtitle: 'Master complex character outlines with dynamic posing.',
    category: 'Characters',
    difficulty: 'Advanced',
    durationMinutes: 15,
    xpReward: 120,
    isPremium: true,
    thumbnailUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&q=80',
    type: LessonType.sketch,
    steps: [
      LessonStep(
        title: 'Action Pose',
        description: 'Block out the dynamic katana pose.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/1018/1018919.png', // Samurai/Sword icon
      ),
      LessonStep(
        title: 'Armor Plates',
        description: 'Add detailed samurai armor sections.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253134.png',
      ),
      LessonStep(
        title: 'Cyberpunk Glow',
        description: 'Define the neon highlights.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/2619/2619213.png',
      ),
    ],
  ),
  const Lesson(
    id: 'delicious-pizza',
    title: 'Pepperoni Pizza',
    subtitle: 'Practice shading and textures with a tasty subject.',
    category: 'Food',
    difficulty: 'Intermediate',
    durationMinutes: 8,
    xpReward: 60,
    isPremium: false,
    thumbnailUrl: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&q=80',
    type: LessonType.color,
    steps: [
      LessonStep(
        title: 'Crust Foundation',
        description: 'Draw the circular base and crust texture.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253113.png',
      ),
      LessonStep(
        title: 'Toppings',
        description: 'Add pepperoni and melting cheese details.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253134.png',
      ),
      LessonStep(
        title: 'Shading',
        description: 'Add depth to the crust and shadows.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/2619/2619213.png',
      ),
    ],
  ),
  const Lesson(
    id: 'majestic-lion',
    title: 'Lion Portrait',
    subtitle: 'Capture the king of the jungle in this detailed study.',
    category: 'Animals',
    difficulty: 'Advanced',
    durationMinutes: 20,
    xpReward: 150,
    isPremium: true,
    thumbnailUrl: 'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=400&q=80',
    type: LessonType.trace,
    steps: [
      LessonStep(
        title: 'Mane Outline',
        description: 'Draw the large, flowing mane.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253113.png',
      ),
      LessonStep(
        title: 'Facial Features',
        description: 'Detail the eyes and powerful snout.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253134.png',
      ),
      LessonStep(
        title: 'Fur Texture',
        description: 'Add fine lines for realistic fur.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/2619/2619213.png',
      ),
    ],
  ),
  const Lesson(
    id: 'vintage-camera',
    title: 'Retro Camera',
    subtitle: 'Technical drawing practice with geometric shapes.',
    category: 'Objects',
    difficulty: 'Intermediate',
    durationMinutes: 10,
    xpReward: 80,
    isPremium: false,
    thumbnailUrl: 'https://images.unsplash.com/photo-1516035069371-29a1b244cc32?w=400&q=80',
    type: LessonType.sketch,
    steps: [
      LessonStep(
        title: 'Main Body',
        description: 'Draw the rectangular camera body.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253113.png',
      ),
      LessonStep(
        title: 'Lens System',
        description: 'Add concentric circles for the lens.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/3253/3253134.png',
      ),
      LessonStep(
        title: 'Dials & Knobs',
        description: 'Add the small control details.',
        templateUrl: 'https://cdn-icons-png.flaticon.com/512/2619/2619213.png',
      ),
    ],
  ),
];

final List<LessonCategory> lessonCategories = [
  LessonCategory(
    id: 'all',
    label: 'All',
    lessons: sampleLessons,
  ),
  LessonCategory(
    id: 'animals',
    label: 'Animals',
    lessons: sampleLessons.where((l) => l.category == 'Animals').toList(),
  ),
  LessonCategory(
    id: 'characters',
    label: 'Characters',
    lessons: sampleLessons.where((l) => l.category == 'Characters').toList(),
  ),
  LessonCategory(
    id: 'food',
    label: 'Food',
    lessons: sampleLessons.where((l) => l.category == 'Food').toList(),
  ),
  LessonCategory(
    id: 'objects',
    label: 'Objects',
    lessons: sampleLessons.where((l) => l.category == 'Objects').toList(),
  ),
];
