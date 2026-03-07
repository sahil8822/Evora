import 'package:evora/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class AllReviewsScreen extends StatelessWidget {
  const AllReviewsScreen({super.key});
  static const String route = '/all-reviews';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reviews & Ratings',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Rating Summary Header
          SliverToBoxAdapter(
            child: Container(
              margin: EdgeInsets.all(20.w),
              padding: EdgeInsets.all(24.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28.r),
              ),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        '4.8',
                        style: GoogleFonts.montserrat(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4
                                ? Icons.star_rounded
                                : Icons.star_half_rounded,
                            color: Colors.amber,
                            size: 16.sp,
                          );
                        }),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        '120 Reviews',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 32.w),
                  Expanded(
                    child: Column(
                      children: [
                        _buildRatingBar(5, 0.8),
                        _buildRatingBar(4, 0.15),
                        _buildRatingBar(3, 0.03),
                        _buildRatingBar(2, 0.01),
                        _buildRatingBar(1, 0.01),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Reviews List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return _buildReviewCard(index);
              }, childCount: 10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double progress) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          Text(
            '$star',
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppColors.backgroundColor,
                color: Colors.amber,
                minHeight: 6.h,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(int index) {
    final List<String> names = [
      'Rahul Sharma',
      'Ananya Singh',
      'Vikram Jeet',
      'Sneha Kapoor',
    ];
    final List<String> reviews = [
      'Absolutely loved the venue! The decorations were exactly what we discussed. High quality service.',
      'The food was okay, but the management made everything so smooth. Recommended for corporate events.',
      'A bit expensive but worth every penny for the aesthetics and vibes.',
      'Perfect setup for a birthday party. Kids enjoyed a lot!',
    ];

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
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
              Row(
                children: [
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                    child: Text(
                      names[index % 4][0],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        names[index % 4],
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '2 days ago',
                        style: GoogleFonts.poppins(
                          fontSize: 10.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: List.generate(5, (s) {
                  return Icon(
                    Icons.star_rounded,
                    color: Colors.amber,
                    size: 14.sp,
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            reviews[index % 4],
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              color: AppColors.textPrimary.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
