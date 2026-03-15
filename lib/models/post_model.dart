import 'user_model.dart';

class PostModel {
  final String id;
  final UserModel user;
  final List<String> imageUrls;
  final String caption;
  final int likeCount;
  final String timeAgo;
  final bool isLiked;
  final bool isSaved;

  const PostModel({
    required this.id,
    required this.user,
    required this.imageUrls,
    required this.caption,
    required this.likeCount,
    required this.timeAgo,
    required this.isLiked,
    required this.isSaved,
  });

  PostModel copyWith({
    String? id,
    UserModel? user,
    List<String>? imageUrls,
    String? caption,
    int? likeCount,
    String? timeAgo,
    bool? isLiked,
    bool? isSaved,
  }) {
    return PostModel(
      id: id ?? this.id,
      user: user ?? this.user,
      imageUrls: imageUrls ?? this.imageUrls,
      caption: caption ?? this.caption,
      likeCount: likeCount ?? this.likeCount,
      timeAgo: timeAgo ?? this.timeAgo,
      isLiked: isLiked ?? this.isLiked,
      isSaved: isSaved ?? this.isSaved,
    );
  }
}
