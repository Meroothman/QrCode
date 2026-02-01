import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _onboardingKey = 'has_seen_onboarding';
  
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  // Check if user has seen onboarding
  bool get hasSeenOnboarding => _prefs.getBool(_onboardingKey) ?? false;

  // Mark onboarding as seen
  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  // Reset onboarding (useful for testing)
  Future<void> resetOnboarding() async {
    await _prefs.remove(_onboardingKey);
  }
}