import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerFeed extends StatelessWidget {
  const ShimmerFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFF1F1F1),
      highlightColor: const Color(0xFFF8F8F8),
      child: ListView(
        children: [
          const SizedBox(height: 8),
          SizedBox(
            height: 98,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: 7,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    children: [
                      Container(
                        width: 68,
                        height: 68,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(width: 50, height: 9, color: Colors.white),
                    ],
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          ...List<Widget>.generate(3, (_) => const _PostShimmerItem()),
        ],
      ),
    );
  }
}

class _PostShimmerItem extends StatelessWidget {
  const _PostShimmerItem();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Container(width: 90, height: 10, color: Colors.white),
            ],
          ),
        ),
        Container(width: width, height: width, color: Colors.white),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(width: 100, height: 10, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Container(width: 180, height: 10, color: Colors.white),
        ),
        const SizedBox(height: 18),
      ],
    );
  }
}
