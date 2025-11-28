class NutritionPlan {
  final String id;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;
  final List<String> notes;

  const NutritionPlan({
    required this.id,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.notes,
  });

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      id: json['id'] as String,
      calories: json['calories'] as int,
      protein: json['protein'] as int,
      carbs: json['carbs'] as int,
      fats: json['fats'] as int,
      notes: (json['notes'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'notes': notes,
    };
  }
}
