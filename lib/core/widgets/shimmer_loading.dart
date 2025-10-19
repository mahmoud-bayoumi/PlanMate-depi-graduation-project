import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key});

  Widget _shimmerBox({
    double? width,
    required double height,
    BorderRadius? radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade500,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: radius ?? BorderRadius.circular(8),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: CustomScrollView(
        slivers: [
          // Search row (search field + chat icon)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                left: 5,
                right: 5,
                bottom: 8,
              ),
              child: Row(
                children: [
                  // search box placeholder (expanded)
                  Expanded(
                    child: _shimmerBox(
                      height: 48,
                      radius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // chat icon placeholder (square)
                  _shimmerBox(
                    width: 48,
                    height: 48,
                    radius: BorderRadius.circular(12),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Title "Category"
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _shimmerBox(
                  width: 140,
                  height: 20,
                  radius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          // Horizontal categories shimmer list
          SliverToBoxAdapter(
            child: SizedBox(
              height: 95,
              child: ListView.separated(
                padding: const EdgeInsets.only(left: 5, right: 10),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return _shimmerBox(
                    width: 85,
                    height: 90,
                    radius: BorderRadius.circular(20),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),

          // Section title placeholder (e.g., "X Events")
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _shimmerBox(
                  width: 200,
                  height: 20,
                  radius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 15)),

          // Vertical list of event cards placeholders
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  children: [
                    // big image placeholder
                    _shimmerBox(
                      width: w,
                      height: 160,
                      radius: BorderRadius.circular(16),
                    ),
                    const SizedBox(height: 10),
                    // title line
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _shimmerBox(
                        width: w * 0.6,
                        height: 16,
                        radius: BorderRadius.circular(6),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // meta line
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _shimmerBox(
                        width: w * 0.4,
                        height: 14,
                        radius: BorderRadius.circular(6),
                      ),
                    ),
                  ],
                ),
              );
            }, childCount: 6),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }
}