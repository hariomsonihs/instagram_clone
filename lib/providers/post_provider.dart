import 'package:flutter/foundation.dart';

import '../models/post_model.dart';
import '../models/user_model.dart';
import '../repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  PostProvider({required PostRepository repository}) : _repository = repository;

  final PostRepository _repository;

  static const int _pageSize = 10;

  List<PostModel> _posts = <PostModel>[];
  int _currentPage = 0;
  bool _isInitialLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  String? _errorMessage;

  List<PostModel> get posts => _posts;
  bool get isInitialLoading => _isInitialLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  List<UserModel> get storyUsers {
    final seenUsernames = <String>{};
    final users = <UserModel>[];

    for (final post in _posts) {
      if (seenUsernames.add(post.user.username)) {
        users.add(post.user);
      }
    }

    return users;
  }

  PostModel? getPostById(String postId) {
    try {
      return _posts.firstWhere((post) => post.id == postId);
    } catch (_) {
      return null;
    }
  }

  Future<void> loadInitialPosts() async {
    _isInitialLoading = true;
    _errorMessage = null;
    _hasMore = true;
    _currentPage = 0;
    notifyListeners();

    try {
      await Future.delayed(const Duration(milliseconds: 1500));
      final fetchedPosts = await _repository.fetchPosts(
        page: 1,
        pageSize: _pageSize,
      );
      _posts = fetchedPosts;
      _currentPage = 1;
      _hasMore = fetchedPosts.length == _pageSize;
    } catch (_) {
      _errorMessage = 'Failed to load posts. Please try again.';
    } finally {
      _isInitialLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMorePosts() async {
    if (_isInitialLoading || _isLoadingMore || !_hasMore) {
      return;
    }

    _isLoadingMore = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final fetchedPosts = await _repository.fetchPosts(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (fetchedPosts.isEmpty) {
        _hasMore = false;
      } else {
        _posts = <PostModel>[..._posts, ...fetchedPosts];
        _currentPage = nextPage;
        _hasMore = fetchedPosts.length == _pageSize;
      }
    } catch (_) {
      _errorMessage = 'Could not load more posts.';
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  void toggleLike(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) {
      return;
    }

    final post = _posts[index];
    final willLike = !post.isLiked;

    _posts[index] = post.copyWith(
      isLiked: willLike,
      likeCount: willLike
          ? post.likeCount + 1
          : (post.likeCount - 1).clamp(0, 999999),
    );

    notifyListeners();
  }

  void toggleSave(String postId) {
    final index = _posts.indexWhere((post) => post.id == postId);
    if (index == -1) {
      return;
    }

    final post = _posts[index];
    _posts[index] = post.copyWith(isSaved: !post.isSaved);
    notifyListeners();
  }
}
