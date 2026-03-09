import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});
  static const String route = '/security';

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
          'Security',
          style: GoogleFonts.montserrat(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            _buildSecurityOption(
              Icons.lock_outline_rounded,
              'Change Password',
              'Update your login password',
            ),
            _buildSecurityOption(
              Icons.fingerprint_rounded,
              'Biometric Login',
              'Use Fingerprint or FaceID',
            ),
            _buildSecurityOption(
              Icons.devices_rounded,
              'Active Sessions',
              'Manage your logged in devices',
            ),
            _buildSecurityOption(
              Icons.delete_outline_rounded,
              'Delete Account',
              'Permanently remove your data',
              isDestructive: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecurityOption(
    IconData icon,
    String title,
    String subtitle, {
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isDestructive
                  ? Colors.red.withOpacity(0.08)
                  : AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              icon,
              color: isDestructive ? Colors.redAccent : AppColors.textPrimary,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: isDestructive
                        ? Colors.redAccent
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios_rounded,
            size: 12.sp,
            color: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}

