import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/post_provider.dart';
import '../utils/app_constants.dart';
import '../widgets/instagram_app_bar.dart';
import '../widgets/post_card.dart';
import '../widgets/shimmer_feed.dart';
import '../widgets/stories_section.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  late final ScrollController _scrollController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 500) {
      context.read<PostProvider>().loadMorePosts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const InstagramAppBar(),
      body: Consumer<PostProvider>(
        builder: (context, provider, _) {
          if (provider.isInitialLoading) return const ShimmerFeed();

          if (provider.posts.isEmpty && provider.errorMessage != null) {
            return _ErrorState(
              message: provider.errorMessage!,
              onRetry: provider.loadInitialPosts,
            );
          }

          if (provider.posts.isEmpty) return const _EmptyState();

          return RefreshIndicator(
            onRefresh: provider.loadInitialPosts,
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: provider.posts.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return StoriesSection(users: provider.storyUsers);
                }
                if (index == provider.posts.length + 1) {
                  return _FeedFooter(provider: provider);
                }
                return PostCard(postId: provider.posts[index - 1].id);
              },
            ),
          );
        },
      ),
      bottomNavigationBar: _InstagramBottomNav(
        selectedIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}

// ── Bottom Navigation Bar ────────────────────────────────────────────────────

class _InstagramBottomNav extends StatelessWidget {
  const _InstagramBottomNav({
    required this.selectedIndex,
    required this.onTap,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppConstants.borderColor)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: selectedIndex == 0
                    ? Icons.home
                    : Icons.home_outlined,
                selected: selectedIndex == 0,
                onTap: () => onTap(0),
              ),
              _NavItem(
                icon: selectedIndex == 1
                    ? Icons.smart_display
                    : Icons.smart_display_outlined,
                selected: selectedIndex == 1,
                onTap: () => onTap(1),
              ),
              // Send icon with red dot
              GestureDetector(
                onTap: () => onTap(2),
                child: SizedBox(
                  width: 48,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        selectedIndex == 2
                            ? Icons.send
                            : Icons.send_outlined,
                        size: 26,
                        color: Colors.black,
                      ),
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppConstants.instagramRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _NavItem(
                icon: selectedIndex == 3
                    ? Icons.search
                    : Icons.search,
                selected: selectedIndex == 3,
                onTap: () => onTap(3),
              ),
              // Profile avatar
              GestureDetector(
                onTap: () => onTap(4),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: selectedIndex == 4
                        ? Border.all(color: Colors.black, width: 2)
                        : null,
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: 'https://i.pravatar.cc/150?img=12',
                      width: 30,
                      height: 30,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => Container(
                        color: const Color(0xFFDBDBDB),
                        child: const Icon(
                          Icons.person,
                          size: 18,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 48,
        height: 50,
        child: Icon(icon, size: 27, color: Colors.black),
      ),
    );
  }
}

// ── Feed Footer ──────────────────────────────────────────────────────────────

class _FeedFooter extends StatelessWidget {
  const _FeedFooter({required this.provider});
  final PostProvider provider;

  @override
  Widget build(BuildContext context) {
    if (provider.isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }
    if (provider.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Center(
          child: TextButton(
            onPressed: provider.loadMorePosts,
            child: const Text('Retry loading posts'),
          ),
        ),
      );
    }
    if (!provider.hasMore) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(
          child: Text(
            'You\'re all caught up',
            style: TextStyle(
              color: AppConstants.lightTextColor,
              fontSize: 13,
            ),
          ),
        ),
      );
    }
    return const SizedBox(height: 12);
  }
}

// ── Error / Empty States ─────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 40, color: Colors.black54),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'No posts available right now.',
        style: TextStyle(
          fontSize: 15,
          color: AppConstants.lightTextColor,
        ),
      ),
    );
  }
}
