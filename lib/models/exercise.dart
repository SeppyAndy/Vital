class Exercise {
  final String id;
  final String name;
  final String primaryMuscleGroup;
  final String equipment;
  final String description;

  const Exercise({
    required this.id,
    required this.name,
    required this.primaryMuscleGroup,
    required this.equipment,
    required this.description,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      primaryMuscleGroup: json['primaryMuscleGroup'] as String,
      equipment: json['equipment'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'primaryMuscleGroup': primaryMuscleGroup,
      'equipment': equipment,
      'description': description,
    };
  }
}
