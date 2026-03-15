import 'dart:math';

import '../models/post_model.dart';
import '../models/user_model.dart';

class PostRepository {
  final List<String> _usernames = const [
    'alex_rivera',
    'sophie.lee',
    'travelwithmia',
    'noahsmith',
    'streetbytes',
    'fitjames',
    'ananya.dev',
    'elijah.media',
    'zara_joy',
    'urbanframes',
    'isla.codes',
    'masonflicks',
  ];

  final List<String> _captions = const [
    'Golden hour and city lights.',
    'Coffee first, then everything else.',
    'Weekend dump. Swipe through.',
    'Tiny moments, big memories.',
    'Captured this on the way home.',
    'Still thinking about this view.',
    'Simple things, sharp details.',
    'Another page from today.',
  ];

  Future<List<PostModel>> fetchPosts({
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (page > 6) {
      return <PostModel>[];
    }

    final random = Random(page);
    final start = (page - 1) * pageSize;

    return List<PostModel>.generate(pageSize, (index) {
      final postNumber = start + index + 1;
      final userName = _usernames[postNumber % _usernames.length];
      final imageCount = (postNumber % 3) + 1;

      final user = UserModel(
        id: 'user_$postNumber',
        username: userName,
        profileImageUrl:
            'https://i.pravatar.cc/150?img=${(postNumber % 70) + 1}',
        hasStory: random.nextBool(),
      );

      return PostModel(
        id: 'post_$postNumber',
        user: user,
        imageUrls: List<String>.generate(
          imageCount,
          (imageIndex) =>
              'https://picsum.photos/seed/post_${postNumber}_$imageIndex/1080/1080',
        ),
        caption: _captions[postNumber % _captions.length],
        likeCount: 90 + (postNumber * 4),
        timeAgo: '${(postNumber % 59) + 1}m',
        isLiked: false,
        isSaved: false,
      );
    });
  }
}
