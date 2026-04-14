import 'package:evora/screens/home/widgets/home_search_bar.dart';
import 'package:evora/screens/home/widgets/category_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController? controller;
  final Function(int)? onCategorySelected;
  final Color backgroundColor;
  const PinnedHeaderDelegate({
    this.controller,
    this.onCategorySelected,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: shrinkOffset > 0 ? topPadding : 0),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: shrinkOffset > 0
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          SizedBox(height: 12.h),
          HomeSearchBar(controller: controller),
          SizedBox(height: 14.h),
          CategoryTabs(onCategorySelected: onCategorySelected),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 220.h; // Ample space for search, tabs, and status bar

  @override
  double get minExtent => 220.h; // Fixed pinned height

  @override
  bool shouldRebuild(covariant PinnedHeaderDelegate oldDelegate) {
    return oldDelegate.backgroundColor != backgroundColor;
  }
}
