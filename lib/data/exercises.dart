/// Exercise definitions for Rewire bodyweight workouts (spec §4.1).
library;

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.category,
    required this.defaultSets,
    required this.defaultReps,
    required this.isTimed,
    required this.unit,
    required this.difficulty,
    required this.description,
    required this.targetMuscles,
    required this.imageAssetPath,
  });

  final String id;
  final String name;
  final String category; // 'Upper', 'Lower', 'Core', 'Cardio'
  final int defaultSets;
  final int defaultReps;
  final bool isTimed;
  final String unit; // 'Repetisi' or 'Detik'
  final String difficulty; // 'Beginner' or 'Intermediate'
  final String description;
  final String targetMuscles;
  final String imageAssetPath;
}

const List<Exercise> kAllExercises = [
  // Upper Body
  Exercise(
    id: 'pushup',
    name: 'Push-up',
    category: 'Upper',
    defaultSets: 3,
    defaultReps: 12,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description: 'Latihan dasar tubuh bagian atas untuk menguatkan dada, bahu, dan trisep.',
    targetMuscles: 'Dada & Trisep',
    imageAssetPath: 'assets/images/exercises/pushup.png',
  ),
  Exercise(
    id: 'knee_pushup',
    name: 'Knee Push-up',
    category: 'Upper',
    defaultSets: 3,
    defaultReps: 15,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description:
        'Variasi push-up bertumpu pada lutut untuk membangun kekuatan dasar.',
    targetMuscles: 'Dada & Lengan',
    imageAssetPath: 'assets/images/exercises/knee_pushup.png',
  ),
  Exercise(
    id: 'diamond_pushup',
    name: 'Diamond Push-up',
    category: 'Upper',
    defaultSets: 3,
    defaultReps: 8,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Intermediate',
    description: 'Push-up dengan tangan membentuk wajik di bawah dada untuk aktivasi trisep maksimal.',
    targetMuscles: 'Trisep & Dada Bagian Dalam',
    imageAssetPath: 'assets/images/exercises/diamond_pushup.png',
  ),
  Exercise(
    id: 'pike_pushup',
    name: 'Pike Push-up',
    category: 'Upper',
    defaultSets: 3,
    defaultReps: 10,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Intermediate',
    description: 'Gerakan tubuh bagian atas membentuk segitiga untuk melatih kekuatan bahu.',
    targetMuscles: 'Bahu & Punggung Atas',
    imageAssetPath: 'assets/images/exercises/pike_pushup.png',
  ),

  // Lower Body
  Exercise(
    id: 'squat',
    name: 'Squat',
    category: 'Lower',
    defaultSets: 3,
    defaultReps: 15,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description: 'Gerakan dasar tubuh bagian bawah untuk memperkuat paha depan dan bokong.',
    targetMuscles: 'Paha & Bokong',
    imageAssetPath: 'assets/images/exercises/squat.png',
  ),
  Exercise(
    id: 'lunge',
    name: 'Lunge',
    category: 'Lower',
    defaultSets: 3,
    defaultReps: 12,
    isTimed: false,
    unit: 'Repetisi / sisi',
    difficulty: 'Beginner',
    description:
        'Langkah maju teratur melatih kestabilan kaki, paha, dan pinggul.',
    targetMuscles: 'Paha Depan & Keseimbangan',
    imageAssetPath: 'assets/images/exercises/lunge.png',
  ),
  Exercise(
    id: 'jump_squat',
    name: 'Jump Squat',
    category: 'Lower',
    defaultSets: 3,
    defaultReps: 10,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Intermediate',
    description: 'Squat eksplosif dengan lompatan untuk kekuatan otot kaki dan pembakaran kalori.',
    targetMuscles: 'Daya Ledak Kaki & Betis',
    imageAssetPath: 'assets/images/exercises/jump_squat.png',
  ),
  Exercise(
    id: 'wall_sit',
    name: 'Wall Sit',
    category: 'Lower',
    defaultSets: 3,
    defaultReps: 30,
    isTimed: true,
    unit: 'Detik',
    difficulty: 'Beginner',
    description: 'Menahan posisi duduk bersandar pada dinding untuk melatih daya tahan isometrik.',
    targetMuscles: 'Ketahanan Paha Depan',
    imageAssetPath: 'assets/images/exercises/wall_sit.png',
  ),

  // Core
  Exercise(
    id: 'plank',
    name: 'Plank',
    category: 'Core',
    defaultSets: 3,
    defaultReps: 30,
    isTimed: true,
    unit: 'Detik',
    difficulty: 'Beginner',
    description: 'Tahan posisi lurus dengan siku untuk memperkuat seluruh otot inti tubuh.',
    targetMuscles: 'Otot Inti & Postur',
    imageAssetPath: 'assets/images/exercises/plank.png',
  ),
  Exercise(
    id: 'crunch',
    name: 'Crunch',
    category: 'Core',
    defaultSets: 3,
    defaultReps: 15,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description: 'Gerakan mengangkat punggung atas dari lantai untuk aktivasi perut bagian atas.',
    targetMuscles: 'Perut Bagian Atas',
    imageAssetPath: 'assets/images/exercises/crunch.png',
  ),
  Exercise(
    id: 'mountain_climber',
    name: 'Mountain Climber',
    category: 'Core',
    defaultSets: 3,
    defaultReps: 20,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Intermediate',
    description: 'Dari posisi push-up menarik lutut bergantian secara cepat, melatih inti dan cardio.',
    targetMuscles: 'Perut Bawah & Cardio Inti',
    imageAssetPath: 'assets/images/exercises/mountain_climber.png',
  ),
  Exercise(
    id: 'bicycle_crunch',
    name: 'Bicycle Crunch',
    category: 'Core',
    defaultSets: 3,
    defaultReps: 15,
    isTimed: false,
    unit: 'Repetisi / sisi',
    difficulty: 'Intermediate',
    description: 'Gerakan mengayuh sepeda terlentang untuk menargetkan otot samping perut (obliques).',
    targetMuscles: 'Perut Samping (Obliques)',
    imageAssetPath: 'assets/images/exercises/bicycle_crunch.png',
  ),

  // Cardio
  Exercise(
    id: 'jumping_jack',
    name: 'Jumping Jack',
    category: 'Cardio',
    defaultSets: 3,
    defaultReps: 20,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description: 'Melompat membuka kaki dan merentangkan tangan ke atas untuk pemanasan kardio.',
    targetMuscles: 'Kardiovaskular & Seluruh Tubuh',
    imageAssetPath: 'assets/images/exercises/jumping_jack.png',
  ),
  Exercise(
    id: 'high_knees',
    name: 'High Knees',
    category: 'Cardio',
    defaultSets: 3,
    defaultReps: 20,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Beginner',
    description: 'Lari di tempat dengan mengangkat lutut setinggi pinggang secara dinamis.',
    targetMuscles: 'Ketahanan & Fleksor Pinggul',
    imageAssetPath: 'assets/images/exercises/high_knees.png',
  ),
  Exercise(
    id: 'burpee',
    name: 'Burpee',
    category: 'Cardio',
    defaultSets: 3,
    defaultReps: 8,
    isTimed: false,
    unit: 'Repetisi',
    difficulty: 'Intermediate',
    description: 'Gerakan squat, plank, push-up, dan lompat dalam satu siklus pembakaran energi penuh.',
    targetMuscles: 'Seluruh Tubuh & Daya Tahan',
    imageAssetPath: 'assets/images/exercises/burpee.png',
  ),
];

Exercise? findExerciseById(String id) {
  for (final ex in kAllExercises) {
    if (ex.id == id) return ex;
  }
  return null;
}
