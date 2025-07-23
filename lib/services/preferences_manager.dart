import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static const String _onboardingCompletedKey = 'onboarding_completed';

  static Future<bool> isOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingCompletedKey) ?? false;
  }

  static Future<void> setOnboardingCompleted() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompletedKey, true);
  }

  static Future<void> clearOnboardingStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingCompletedKey);
  }
}