import 'package:cached_network_image/cached_network_image.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  bool _isOnline = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar
        Container(
          width: 52.w,
          height: 52.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.accentColor, width: 2),
            image: const DecorationImage(
              image: CachedNetworkImageProvider(
                'https://i.pravatar.cc/150?u=partner',
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 14.w),
        // Greeting
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Evening, Sahil 👋",
                style: GoogleFonts.montserrat(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Royal Tent House",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
        // Online/Offline toggle
        GestureDetector(
          onTap: () => setState(() => _isOnline = !_isOnline),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: _isOnline
                  ? AppColors.successColor.withOpacity(0.1)
                  : AppColors.errorColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: _isOnline
                    ? AppColors.successColor.withOpacity(0.3)
                    : AppColors.errorColor.withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8.w,
                  height: 8.w,
                  decoration: BoxDecoration(
                    color: _isOnline
                        ? AppColors.successColor
                        : AppColors.errorColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (_isOnline
                                    ? AppColors.successColor
                                    : AppColors.errorColor)
                                .withOpacity(0.5),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  _isOnline ? "Online" : "Offline",
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: _isOnline
                        ? AppColors.successColor
                        : AppColors.errorColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
