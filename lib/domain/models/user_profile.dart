class UserProfile {
  final String name;
  final String instaLink;
  final String youtubeLink;
  final List<Map<String, String>> customSocials;

  const UserProfile({
    required this.name,
    required this.instaLink,
    required this.youtubeLink,
    this.customSocials = const [],
  });

  UserProfile copyWith({
    String? name,
    String? instaLink,
    String? youtubeLink,
    List<Map<String, String>>? customSocials,
  }) {
    return UserProfile(
      name: name ?? this.name,
      instaLink: instaLink ?? this.instaLink,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      customSocials: customSocials ?? this.customSocials,
    );
  }

  factory UserProfile.empty() {
    return const UserProfile(
      name: '',
      instaLink: '',
      youtubeLink: '',
      customSocials: [],
    );
  }
}
