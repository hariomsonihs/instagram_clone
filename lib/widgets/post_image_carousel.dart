import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
            itemBuilder: (_, index) => _ZoomableImage(
              imageUrl: widget.imageUrls[index],
              size: width,
            ),
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

class _ZoomableImage extends StatefulWidget {
  const _ZoomableImage({required this.imageUrl, required this.size});

  final String imageUrl;
  final double size;

  @override
  State<_ZoomableImage> createState() => _ZoomableImageState();
}

class _ZoomableImageState extends State<_ZoomableImage> {
  double _scale = 1.0;
  double _baseScale = 1.0;
  Offset _offset = Offset.zero;
  Offset _normalizedOffset = Offset.zero;

  void _onScaleStart(ScaleStartDetails details) {
    _baseScale = _scale;
    _normalizedOffset = (_offset - details.focalPoint) / _scale;
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount < 2) return;
    setState(() {
      _scale = (_baseScale * details.scale).clamp(1.0, 4.0);
      _offset = details.focalPoint + _normalizedOffset * _scale;
    });
  }

  void _onScaleEnd(ScaleEndDetails details) {
    if (_scale <= 1.05) {
      setState(() {
        _scale = 1.0;
        _offset = Offset.zero;
      });
    }
  }

  void _onDoubleTap() {
    setState(() {
      if (_scale > 1.0) {
        _scale = 1.0;
        _offset = Offset.zero;
      } else {
        _scale = 2.5;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onDoubleTap: _onDoubleTap,
      child: ClipRect(
        child: Transform(
          transform: Matrix4.identity()
            ..translateByDouble(_offset.dx, _offset.dy, 0, 1)
            ..scaleByDouble(_scale, _scale, 1, 1),
          alignment: Alignment.center,
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            width: widget.size,
            height: widget.size,
            placeholder: (_, __) => Container(
              color: const Color(0xFFF4F4F4),
              alignment: Alignment.center,
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => Container(
              color: const Color(0xFFF0F0F0),
              alignment: Alignment.center,
              child: const Icon(
                Icons.broken_image_outlined,
                color: Colors.black38,
                size: 34,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
