import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/user_profile.dart';
import 'shared_prefs_provider.dart';

class UserNotifier extends StateNotifier<UserProfile> {
  final Ref _ref;

  UserNotifier(this._ref) : super(UserProfile.empty()) {
    _loadProfile();
  }

  void _loadProfile() {
    final prefs = _ref.read(preferencesServiceProvider);
    final data = prefs.getUserProfile();
    state = UserProfile(
      name: data['name'] ?? '',
      instaLink: data['instaLink'] ?? '',
      youtubeLink: data['youtubeLink'] ?? '',
    );
  }

  Future<void> saveProfile({
    required String name,
    required String instaLink,
    required String youtubeLink,
  }) async {
    final prefs = _ref.read(preferencesServiceProvider);
    await prefs.saveUserProfile(
      name: name,
      instaLink: instaLink,
      youtubeLink: youtubeLink,
    );
    state = UserProfile(
      name: name,
      instaLink: instaLink,
      youtubeLink: youtubeLink,
    );
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserProfile>((ref) {
  return UserNotifier(ref);
});
