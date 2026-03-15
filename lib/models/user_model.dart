class UserModel {
  final String id;
  final String username;
  final String profileImageUrl;
  final bool hasStory;

  const UserModel({
    required this.id,
    required this.username,
    required this.profileImageUrl,
    required this.hasStory,
  });
}
