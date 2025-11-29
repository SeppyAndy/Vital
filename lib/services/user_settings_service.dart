import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_settings.dart';

/// Simple persistence layer for user onboarding + basic profile settings.
class UserSettingsService {
  UserSettingsService._internal();

  static final UserSettingsService instance = UserSettingsService._internal();

  final UserSettings settings = UserSettings();

  bool _onboardingComplete = false;

  bool get onboardingComplete => _onboardingComplete;

  /// Load settings and onboarding flag from SharedPreferences.
  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    final age = prefs.getInt('age');
    final height = prefs.getDouble('height');
    final weight = prefs.getDouble('weight');
    final goal = prefs.getString('goal');
    final experience = prefs.getString('experience');
    final complete = prefs.getBool('onboarding_complete') ?? false;

    if (age != null && age > 0) {
      settings.age = age;
    }
    if (height != null && height > 0) {
      settings.heightCm = height;
    }
    if (weight != null && weight > 0) {
      settings.weightKg = weight;
    }
    if (goal != null && goal.isNotEmpty) {
      settings.goal = goal;
    }
    if (experience != null && experience.isNotEmpty) {
      settings.experienceLevel = experience;
    }

    _onboardingComplete = complete;
  }

  /// Save current settings + onboarding flag to SharedPreferences.
  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('age', settings.age ?? -1);
    await prefs.setDouble('height', settings.heightCm ?? -1);
    await prefs.setDouble('weight', settings.weightKg ?? -1);
    await prefs.setString('goal', settings.goal ?? '');
    await prefs.setString('experience', settings.experienceLevel ?? '');
    await prefs.setBool('onboarding_complete', _onboardingComplete);
  }

  /// Mark onboarding as completed and persist that flag.
  Future<void> markOnboardingComplete() async {
    _onboardingComplete = true;
    await save();
  }

  /// Reset all stored values and clear onboarding completion.
  Future<void> resetAll() async {
    settings.age = null;
    settings.heightCm = null;
    settings.weightKg = null;
    settings.goal = null;
    settings.experienceLevel = null;
    _onboardingComplete = false;
    await save();
  }

  // Convenience setters for individual fields.
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
}
