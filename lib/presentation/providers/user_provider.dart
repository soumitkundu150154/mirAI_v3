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
      customSocials: (data['customSocials'] as List?)?.cast<Map<String, String>>() ?? [],
    );
  }

  Future<void> saveProfile({
    required String name,
    required String instaLink,
    required String youtubeLink,
    List<Map<String, String>>? customSocials,
  }) async {
    final newCustomSocials = customSocials ?? state.customSocials;
    final prefs = _ref.read(preferencesServiceProvider);
    await prefs.saveUserProfile(
      name: name,
      instaLink: instaLink,
      youtubeLink: youtubeLink,
      customSocials: newCustomSocials,
    );
    state = UserProfile(
      name: name,
      instaLink: instaLink,
      youtubeLink: youtubeLink,
      customSocials: newCustomSocials,
    );
  }

  Future<void> addCustomSocial(String platform, String account) async {
    final newSocials = List<Map<String, String>>.from(state.customSocials);
    newSocials.add({'platform': platform, 'account': account});
    
    await saveProfile(
      name: state.name,
      instaLink: state.instaLink,
      youtubeLink: state.youtubeLink,
      customSocials: newSocials,
    );
  }

  Future<void> removeCustomSocial(int index) async {
    final newSocials = List<Map<String, String>>.from(state.customSocials);
    if (index >= 0 && index < newSocials.length) {
      newSocials.removeAt(index);
      await saveProfile(
        name: state.name,
        instaLink: state.instaLink,
        youtubeLink: state.youtubeLink,
        customSocials: newSocials,
      );
    }
  }
}

final userProvider = StateNotifierProvider<UserNotifier, UserProfile>((ref) {
  return UserNotifier(ref);
});
