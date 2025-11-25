import 'exercise.dart';

class WorkoutProgram {
  final String id;
  final String dayName;
  final List<String> muscleGroups;
  final List<Exercise> exercises;

  const WorkoutProgram({
    required this.id,
    required this.dayName,
    required this.muscleGroups,
    required this.exercises,
  });

  factory WorkoutProgram.fromJson(Map<String, dynamic> json) {
    return WorkoutProgram(
      id: json['id'] as String,
      dayName: json['dayName'] as String,
      muscleGroups: (json['muscleGroups'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      exercises: (json['exercises'] as List<dynamic>)
          .map((e) => Exercise.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dayName': dayName,
      'muscleGroups': muscleGroups,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}
