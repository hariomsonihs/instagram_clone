import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/user_model.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({super.key, required this.user, this.isYourStory = false});

  final UserModel user;
  final bool isYourStory;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 68,
                height: 68,
                padding: const EdgeInsets.all(2.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: (!isYourStory && user.hasStory)
                      ? const LinearGradient(
                          colors: [
                            Color(0xFFFEDA75),
                            Color(0xFFF58529),
                            Color(0xFFDD2A7B),
                            Color(0xFF8134AF),
                            Color(0xFF515BD4),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        )
                      : null,
                  color: (!isYourStory && user.hasStory)
                      ? null
                      : const Color(0xFFDBDBDB),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: user.profileImageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFFF0F0F0),
                        child: const Icon(
                          Icons.person,
                          color: Colors.black45,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              if (isYourStory)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0095F6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            isYourStory ? 'Your story' : user.username,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11.5,
              color: Colors.black,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
