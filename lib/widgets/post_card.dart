import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/post_model.dart';
import '../providers/post_provider.dart';
import '../utils/app_constants.dart';
import 'post_image_carousel.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.postId});

  final String postId;

  void _showComingSoonSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Feature coming soon'),
          duration: Duration(milliseconds: 1300),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PostProvider, PostModel?>(
      selector: (_, provider) => provider.getPostById(postId),
      builder: (context, post, _) {
        if (post == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  // Avatar with gradient ring
                  Container(
                    width: 38,
                    height: 38,
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFEDA75),
                          Color(0xFFF58529),
                          Color(0xFFDD2A7B),
                          Color(0xFF8134AF),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(1.5),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: post.user.profileImageUrl,
                          width: 32,
                          height: 32,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            color: const Color(0xFFF0F0F0),
                            child: const Icon(Icons.person, size: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          post.user.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13.5,
                          ),
                        ),
                        const SizedBox(width: 4),
                        // Verified badge (shown for some users)
                        if (post.user.id.hashCode % 3 == 0)
                          const Icon(
                            Icons.verified,
                            color: Color(0xFF0095F6),
                            size: 14,
                          ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showComingSoonSnackBar(context),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.more_vert, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            // ── Image ────────────────────────────────────────────────
            PostImageCarousel(imageUrls: post.imageUrls),

            // ── Action Row ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              child: Row(
                children: [
                  // Like
                  _ActionButton(
                    icon: post.isLiked
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: post.isLiked
                        ? AppConstants.instagramRed
                        : Colors.black,
                    size: 26,
                    count: post.likeCount,
                    onTap: () =>
                        context.read<PostProvider>().toggleLike(post.id),
                  ),
                  const SizedBox(width: 2),
                  // Comment
                  _ActionButton(
                    icon: Icons.chat_bubble_outline,
                    color: Colors.black,
                    size: 24,
                    count: post.likeCount ~/ 80,
                    onTap: () => _showComingSoonSnackBar(context),
                  ),
                  const SizedBox(width: 2),
                  // Repost
                  _ActionButton(
                    icon: Icons.repeat_rounded,
                    color: Colors.black,
                    size: 24,
                    count: post.likeCount ~/ 120,
                    onTap: () => _showComingSoonSnackBar(context),
                  ),
                  const SizedBox(width: 2),
                  // Share / Send
                  _ActionButton(
                    icon: Icons.send_outlined,
                    color: Colors.black,
                    size: 23,
                    count: post.likeCount ~/ 40,
                    onTap: () => _showComingSoonSnackBar(context),
                  ),
                  const Spacer(),
                  // Save
                  IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 20,
                    onPressed: () =>
                        context.read<PostProvider>().toggleSave(post.id),
                    icon: Icon(
                      post.isSaved
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      size: 26,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),

            // ── Caption ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 13.5,
                    height: 1.4,
                  ),
                  children: [
                    TextSpan(
                      text: '${post.user.username} ',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    TextSpan(text: post.caption),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                post.timeAgo,
                style: const TextStyle(
                  color: AppConstants.lightTextColor,
                  fontSize: 11.5,
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 0.5, thickness: 0.5),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.size,
    required this.count,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final double size;
  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: color, size: size),
            if (count > 0) ...[
              const SizedBox(width: 5),
              Text(
                _formatCount(count),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatCount(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}k';
    return '$n';
  }
}
