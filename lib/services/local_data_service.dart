import '../models/exercise.dart';
import '../models/nutrition_plan.dart';
import '../models/progress_entry.dart';
import '../models/user_profile.dart';
import '../models/workout_program.dart';

class LocalDataService {
  // TODO: Replace sample data with persistent storage or API responses.
  static final UserProfile sampleUser = UserProfile.fromJson({
    'id': 'user-1',
    'name': 'Alex',
    'age': 29,
    'heightCm': 178.0,
    'weightKg': 74.5,
    'goal': 'Build lean muscle and improve endurance',
    'experienceLevel': 'Intermediate',
  });

  static final NutritionPlan sampleNutritionPlan = NutritionPlan.fromJson({
    'id': 'plan-1',
    'calories': 2300,
    'protein': 160,
    'carbs': 210,
    'fats': 70,
    'notes': [
      'Prioritize whole foods and lean protein.',
      'Stay hydrated throughout the day.',
      'Balance carbs around training sessions.',
    ],
  });

  static List<WorkoutProgram> getSampleWorkoutPrograms() {
    final data = [
      {
        'id': 'wp-1',
        'dayName': 'Monday – Push',
        'muscleGroups': ['Chest', 'Shoulders', 'Triceps'],
        'exercises': [
          {
            'id': 'ex-1',
            'name': 'Barbell Bench Press',
            'primaryMuscleGroup': 'Chest',
            'equipment': 'Barbell',
            'description': '3 sets of 8-10 reps, control the descent and drive up.',
          },
          {
            'id': 'ex-2',
            'name': 'Overhead Press',
            'primaryMuscleGroup': 'Shoulders',
            'equipment': 'Dumbbells',
            'description': 'Keep core braced and press overhead with control.',
          },
          {
            'id': 'ex-3',
            'name': 'Tricep Dips',
            'primaryMuscleGroup': 'Triceps',
            'equipment': 'Bodyweight',
            'description': 'Perform 3 sets to near-failure focusing on depth.',
          },
        ],
      },
      {
        'id': 'wp-2',
        'dayName': 'Wednesday – Pull',
        'muscleGroups': ['Back', 'Biceps'],
        'exercises': [
          {
            'id': 'ex-4',
            'name': 'Deadlift',
            'primaryMuscleGroup': 'Back',
            'equipment': 'Barbell',
            'description': 'Warm up thoroughly; perform 4 sets of 5 reps.',
          },
          {
            'id': 'ex-5',
            'name': 'Pull-Ups',
            'primaryMuscleGroup': 'Back',
            'equipment': 'Bodyweight',
            'description': '3 sets of 6-10 reps, full range of motion.',
          },
          {
            'id': 'ex-6',
            'name': 'Hammer Curls',
            'primaryMuscleGroup': 'Biceps',
            'equipment': 'Dumbbells',
            'description': '3 sets of 12 reps focusing on controlled lowering.',
          },
        ],
      },
      {
        'id': 'wp-3',
        'dayName': 'Friday – Legs & Core',
        'muscleGroups': ['Legs', 'Core'],
        'exercises': [
          {
            'id': 'ex-7',
            'name': 'Back Squat',
            'primaryMuscleGroup': 'Legs',
            'equipment': 'Barbell',
            'description': '4 sets of 6-8 reps; maintain upright torso.',
          },
          {
            'id': 'ex-8',
            'name': 'Lunges',
            'primaryMuscleGroup': 'Legs',
            'equipment': 'Dumbbells',
            'description': 'Alternate legs for 3 sets of 10 reps each side.',
          },
          {
            'id': 'ex-9',
            'name': 'Plank',
            'primaryMuscleGroup': 'Core',
            'equipment': 'Bodyweight',
            'description': 'Hold for 45-60 seconds, 3 rounds.',
          },
        ],
      },
    ];

    return data
        .map((program) => WorkoutProgram.fromJson(program))
        .toList(growable: false);
  }

  static List<ProgressEntry> getSampleProgress() {
    final data = [
      {
        'id': 'p-1',
        'label': 'Weight',
        'value': '74.5 kg',
        'change': '-0.4 kg vs last week',
        'date': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'p-2',
        'label': 'Resting HR',
        'value': '58 bpm',
        'change': '-2 bpm vs last week',
        'date': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      },
      {
        'id': 'p-3',
        'label': 'Bench Press',
        'value': '85 kg x 5',
        'change': '+2.5 kg vs last session',
        'date': DateTime.now().subtract(const Duration(days: 5)).toIso8601String(),
      },
    ];

    return data.map((entry) => ProgressEntry.fromJson(entry)).toList();
  }

  static List<Map<String, String>> getInfoTopics() {
    return const [
      {
        'title': 'Training Frequency 101',
        'summary': 'How often to train each muscle group for steady progress.',
      },
      {
        'title': 'Sleep & Recovery',
        'summary': 'Simple habits to improve deep sleep and muscle recovery.',
      },
      {
        'title': 'Hydration Basics',
        'summary': 'Why water timing matters and how to stay consistent.',
      },
    ];
  }
}
