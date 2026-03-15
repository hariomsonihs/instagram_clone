import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PostImageCarousel extends StatefulWidget {
  const PostImageCarousel({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  State<PostImageCarousel> createState() => _PostImageCarouselState();
}

class _PostImageCarouselState extends State<PostImageCarousel> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: width,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, index) {
              return PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  widget.imageUrls[index],
                ),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 4,
                initialScale: PhotoViewComputedScale.covered,
                backgroundDecoration: const BoxDecoration(
                  color: Colors.white,
                ),
                loadingBuilder: (_, __) => Container(
                  color: const Color(0xFFF4F4F4),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF0F0F0),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.black38,
                    size: 34,
                  ),
                ),
              );
            },
          ),
          if (widget.imageUrls.length > 1)
            Positioned(
              bottom: 12,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  widget.imageUrls.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 2.5),
                    width: _currentPage == i ? 8 : 6,
                    height: _currentPage == i ? 8 : 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == i
                          ? const Color(0xFF3797EF)
                          : Colors.white.withValues(alpha: 0.75),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
