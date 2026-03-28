import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences _prefs;

  PreferencesService(this._prefs);

  static const String _keySetupComplete = 'setup_complete';
  static const String _keyUserName = 'user_name';
  static const String _keyInstaLink = 'insta_link';
  static const String _keyYoutubeLink = 'youtube_link';
  static const String _keyIsDarkMode = 'is_dark_mode';

  bool isSetupComplete() {
    return _prefs.getBool(_keySetupComplete) ?? false;
  }

  Future<void> saveSetupComplete(bool value) async {
    await _prefs.setBool(_keySetupComplete, value);
  }

  Future<void> saveUserProfile({
    required String name,
    required String instaLink,
    required String youtubeLink,
  }) async {
    await _prefs.setString(_keyUserName, name);
    await _prefs.setString(_keyInstaLink, instaLink);
    await _prefs.setString(_keyYoutubeLink, youtubeLink);
    await saveSetupComplete(true);
  }

  Map<String, String> getUserProfile() {
    return {
      'name': _prefs.getString(_keyUserName) ?? '',
      'instaLink': _prefs.getString(_keyInstaLink) ?? '',
      'youtubeLink': _prefs.getString(_keyYoutubeLink) ?? '',
    };
  }

  bool isDarkMode() {
    return _prefs.getBool(_keyIsDarkMode) ?? false; // Default to light mode
  }

  Future<void> saveThemeMode(bool isDark) async {
    await _prefs.setBool(_keyIsDarkMode, isDark);
  }
}
