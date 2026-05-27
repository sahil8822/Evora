import 'package:evora/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});
  static const String route = '/my-reviews';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: EdgeInsets.all(20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildReviewCard(index),
                childCount: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120.h,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
        ),
        onPressed: () => context.pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(left: 56.w, bottom: 16.h),
        title: Text(
          'My Reviews',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30.r)),
      ),
    );
  }

  Widget _buildReviewCard(int index) {
    final List<Map<String, dynamic>> reviews = [
      {
        'vendor': 'Royal Decorators',
        'rating': 5,
        'comment':
            'Absolutely stunning work! The stage was perfect and they delivered everything on time. Highly recommend.',
        'date': '2 weeks ago',
      },
      {
        'vendor': 'Majestic Palms Venue',
        'rating': 4,
        'comment':
            'Great venue with amazing views. The staff was helpful, although the parking was a bit tight.',
        'date': '1 month ago',
      },
      {
        'vendor': 'Gourmet World',
        'rating': 5,
        'comment':
            'The food was the highlight of the event. Every guest loved the appetizers and the main course.',
        'date': '3 months ago',
      },
    ];

    final review = reviews[index % reviews.length];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                review['vendor'],
                style: GoogleFonts.poppins(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                review['date'],
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: List.generate(5, (starIndex) {
              return Icon(
                Icons.star_rounded,
                color: starIndex < review['rating']
                    ? Colors.amber
                    : Colors.grey.shade200,
                size: 20.sp,
              );
            }),
          ),
          SizedBox(height: 12.h),
          Text(
            review['comment'],
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.textPrimary.withOpacity(0.7),
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.edit_outlined,
                  size: 16.sp,
                  color: AppColors.primaryColor,
                ),
                label: Text(
                  'Edit',
                  style: GoogleFonts.poppins(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.more_horiz_rounded, color: Colors.grey.shade300),
            ],
          ),
        ],
      ),
    );
  }
}
