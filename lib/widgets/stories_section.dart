import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../utils/app_constants.dart';
import 'story_item.dart';

class StoriesSection extends StatelessWidget {
  const StoriesSection({super.key, required this.users});

  final List<UserModel> users;

  @override
  Widget build(BuildContext context) {
    // Dummy "Your story" user
    const yourStoryUser = UserModel(
      id: 'your_story',
      username: 'Your story',
      profileImageUrl: 'https://i.pravatar.cc/150?img=12',
      hasStory: false,
    );

    final allUsers = [yourStoryUser, ...users];

    return Container(
      height: 106,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppConstants.borderColor)),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        itemCount: allUsers.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 14),
            child: StoryItem(
              user: allUsers[index],
              isYourStory: index == 0,
            ),
          );
        },
      ),
    );
  }
}
