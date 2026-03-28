class UserProfile {
  final String name;
  final String instaLink;
  final String youtubeLink;

  const UserProfile({
    required this.name,
    required this.instaLink,
    required this.youtubeLink,
  });

  UserProfile copyWith({
    String? name,
    String? instaLink,
    String? youtubeLink,
  }) {
    return UserProfile(
      name: name ?? this.name,
      instaLink: instaLink ?? this.instaLink,
      youtubeLink: youtubeLink ?? this.youtubeLink,
    );
  }

  factory UserProfile.empty() {
    return const UserProfile(
      name: '',
      instaLink: '',
      youtubeLink: '',
    );
  }
}
