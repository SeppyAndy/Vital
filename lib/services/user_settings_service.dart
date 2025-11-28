import '../models/user_settings.dart';

class UserSettingsService {
  static final UserSettingsService instance = UserSettingsService._internal();
  UserSettingsService._internal();

  final UserSettings settings = UserSettings();

  void setAge(int age) => settings.age = age;
  void setHeight(double height) => settings.heightCm = height;
  void setWeight(double weight) => settings.weightKg = weight;
  void setGoal(String goal) => settings.goal = goal;
  void setExperienceLevel(String level) => settings.experienceLevel = level;
}
