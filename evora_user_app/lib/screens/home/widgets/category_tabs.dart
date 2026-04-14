import 'package:evora/core/theme/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryTabs extends StatelessWidget {
  final TabController? controller;
  final Function(int)? onCategorySelected;

  const CategoryTabs({super.key, this.controller, this.onCategorySelected});

  static const List<Map<String, dynamic>> categories = [
    {'name': 'All', 'icon': CupertinoIcons.square_grid_2x2},
    {'name': 'Tent House', 'icon': CupertinoIcons.house},
    {'name': 'Decoration', 'icon': CupertinoIcons.sparkles},
    {'name': 'Wedding Garden', 'icon': CupertinoIcons.tree},
    {'name': 'Catering', 'icon': CupertinoIcons.flame},
    {'name': 'DJ', 'icon': CupertinoIcons.music_note_2},
    {'name': 'Cameraman', 'icon': CupertinoIcons.camera},
    {'name': 'Mehendi', 'icon': CupertinoIcons.pencil_circle},
    {'name': 'Wedding Cards', 'icon': CupertinoIcons.mail},
    {'name': 'Corporate', 'icon': CupertinoIcons.briefcase},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      alignment: Alignment.bottomCenter,
      margin: const EdgeInsets.symmetric(vertical: 4).copyWith(bottom: 0),
      child: TabBar(
        controller: controller,
        isScrollable: true,
        onTap: onCategorySelected,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        labelColor: AppColors.primaryColor,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: const BorderSide(width: 3, color: AppColors.primaryColor),
          borderRadius: BorderRadius.circular(3),
        ),
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: categories.map((cat) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(cat['icon'] as IconData, size: 16),
                const SizedBox(width: 8),
                Text(cat['name'] as String),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
