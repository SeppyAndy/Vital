import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_settings.dart';

class UserSettingsService {
  static final UserSettingsService instance = UserSettingsService._internal();
  UserSettingsService._internal();

  final UserSettings settings = UserSettings();

  bool _onboardingComplete = false;

  bool get onboardingComplete => _onboardingComplete;

  void setAge(int age) {
    settings.age = age;
    save();
  }

  void setHeight(double height) {
    settings.heightCm = height;
    save();
  }

  void setWeight(double weight) {
    settings.weightKg = weight;
    save();
  }

  void setGoal(String goal) {
    settings.goal = goal;
    save();
  }

  void setExperienceLevel(String level) {
    settings.experienceLevel = level;
    save();
  }

  Future<void> markOnboardingComplete() async {
    _onboardingComplete = true;
    await save();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('age', settings.age ?? -1);
    await prefs.setDouble('height', settings.heightCm ?? -1);
    await prefs.setDouble('weight', settings.weightKg ?? -1);
    await prefs.setString('goal', settings.goal ?? '');
    await prefs.setString('experience', settings.experienceLevel ?? '');
    await prefs.setBool('onboarding_complete', _onboardingComplete);
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final age = prefs.getInt('age');
    final height = prefs.getDouble('height');
    final weight = prefs.getDouble('weight');
    final goal = prefs.getString('goal');
    final exp = prefs.getString('experience');
    final complete = prefs.getBool('onboarding_complete') ?? false;

    if (age != null && age > 0) settings.age = age;
    if (height != null && height > 0) settings.heightCm = height;
    if (weight != null && weight > 0) settings.weightKg = weight;
    if (goal != null && goal.isNotEmpty) settings.goal = goal;
    if (exp != null && exp.isNotEmpty) settings.experienceLevel = exp;

    _onboardingComplete = complete;
  }
}
