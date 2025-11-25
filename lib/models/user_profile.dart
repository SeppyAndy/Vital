class UserProfile {
  final String id;
  final String name;
  final int age;
  final double heightCm;
  final double weightKg;
  final String goal;
  final String experienceLevel;

  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.goal,
    required this.experienceLevel,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      age: json['age'] as int,
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      goal: json['goal'] as String,
      experienceLevel: json['experienceLevel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'goal': goal,
      'experienceLevel': experienceLevel,
    };
  }
}
