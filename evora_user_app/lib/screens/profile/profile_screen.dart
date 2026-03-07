import 'package:cached_network_image/cached_network_image.dart';
import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/profile/sub_screens/about_screen.dart';
import 'package:evora/screens/profile/sub_screens/help_center_screen.dart';
import 'package:evora/screens/profile/sub_screens/my_reviews_screen.dart';
import 'package:evora/screens/profile/sub_screens/notifications_settings_screen.dart';
import 'package:evora/screens/profile/sub_screens/payment_history_screen.dart';
import 'package:evora/screens/profile/sub_screens/personal_info_screen.dart';
import 'package:evora/screens/profile/sub_screens/saved_vendors_screen.dart';
import 'package:evora/screens/profile/sub_screens/security_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const String route = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Premium Sliver Bar with Profile Info
          _buildSliverAppBar(),

          // Stats & Activity Sections
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  _buildStatsRow(),

                  SizedBox(height: 32.h),
                  _buildSectionHeader('ACCOUNT SETTINGS'),
                  _buildProfileOption(
                    context,
                    Icons.person_outline_rounded,
                    'Personal Info',
                    'Manage your profile details',
                    index: 0,
                    onTap: () => context.push(PersonalInfoScreen.route),
                  ),
                  _buildProfileOption(
                    context,
                    Icons.notifications_none_rounded,
                    'Notifications',
                    'Control your alerts & updates',
                    index: 1,
                    onTap: () =>
                        context.push(NotificationsSettingsScreen.route),
                  ),
                  _buildProfileOption(
                    context,
                    Icons.security_rounded,
                    'Security',
                    'Password & privacy settings',
                    index: 2,
                    onTap: () => context.push(SecurityScreen.route),
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionHeader('MY ACTIVITY'),
                  _buildProfileOption(
                    context,
                    Icons.favorite_border_rounded,
                    'Saved Vendors',
                    'Access your wishlisted services',
                    index: 3,
                    onTap: () => context.push(SavedVendorsScreen.route),
                  ),
                  _buildProfileOption(
                    context,
                    Icons.star_outline_rounded,
                    'My Reviews',
                    'See your feedback history',
                    index: 4,
                    onTap: () => context.push(MyReviewsScreen.route),
                  ),
                  _buildProfileOption(
                    context,
                    Icons.history_rounded,
                    'Payment History',
                    'Track your previous transactions',
                    index: 5,
                    onTap: () => context.push(PaymentHistoryScreen.route),
                  ),

                  SizedBox(height: 32.h),
                  _buildSectionHeader('SUPPORT'),
                  _buildProfileOption(
                    context,
                    Icons.help_outline_rounded,
                    'Help Center',
                    'Get help and support',
                    index: 6,
                    onTap: () => context.push(HelpCenterScreen.route),
                  ),
                  _buildProfileOption(
                    context,
                    Icons.info_outline_rounded,
                    'About Festivo',
                    'Learn more about us',
                    index: 7,
                    onTap: () => context.push(AboutScreen.route),
                  ),

                  SizedBox(height: 40.h),
                  _buildLogoutButton(),
                  SizedBox(height: 120.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      stretch: true,
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: LayoutBuilder(
        builder: (context, constraints) {
          // Show name when collapsed
          final double opacity =
              constraints.biggest.height <= kToolbarHeight + 50.h ? 1.0 : 0.0;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: opacity,
            child: Text(
              'Profile',
              style: GoogleFonts.montserrat(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: LayoutBuilder(
          builder: (context, constraints) {
            // Calculate opacity for the main profile content
            // It should be 1.0 when expanded, and 0.0 when collapsed
            double contentOpacity =
                (constraints.biggest.height - (kToolbarHeight + 50.h)) / 100.h;
            contentOpacity = contentOpacity.clamp(0.0, 1.0);

            return Container(
              color: Colors.white,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Decorative Gradients
                  Positioned(
                    top: -100.h,
                    right: -100.w,
                    child: Opacity(
                      opacity: contentOpacity,
                      child: Container(
                        width: 300.w,
                        height: 300.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.withOpacity(0.05),
                        ),
                      ),
                    ),
                  ),

                  Opacity(
                    opacity: contentOpacity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 40.h),
                        // Animated Image Ring
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryColor,
                                    AppColors.accentColor.withOpacity(0.5),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 56.r,
                                backgroundColor: Colors.white,
                                child: CircleAvatar(
                                  radius: 51.r,
                                  backgroundImage: const CachedNetworkImageProvider(
                                    'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&q=80&w=200',
                                  ),
                                ),
                              ),
                            ),
                            // Camera Edit Badge
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: Colors.white,
                                size: 14.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          'Sahil Kumar',
                          style: GoogleFonts.montserrat(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified_rounded,
                                color: AppColors.primaryColor,
                                size: 14.sp,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'PREMIUM MEMBER',
                                style: GoogleFonts.montserrat(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.primaryColor,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.r)),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _buildStatCard('12', 'Bookings', Icons.calendar_month_rounded),
        SizedBox(width: 12.w),
        _buildStatCard('45', 'Reviews', Icons.star_rounded),
        SizedBox(width: 12.w),
        _buildStatCard('08', 'Saved', Icons.favorite_rounded),
      ],
    );
  }

  Widget _buildStatCard(String val, String label, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
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
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary.withOpacity(0.5),
                size: 18.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              val,
              style: GoogleFonts.montserrat(
                fontSize: 20.sp,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w, bottom: 16.h),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 11.sp,
          fontWeight: FontWeight.w900,
          color: AppColors.textSecondary.withOpacity(0.5),
          letterSpacing: 2,
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle, {
    required int index,
    VoidCallback? onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 60)),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(bottom: 16.h),
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Icon(icon, color: AppColors.primaryColor, size: 22.sp),
              ),
              SizedBox(width: 20.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
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
                size: 14.sp,
                color: Colors.grey.shade300,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: Colors.red.withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.logout_rounded, color: Colors.redAccent, size: 22.sp),
          SizedBox(width: 12.w),
          Text(
            'LOGOUT ACCOUNT',
            style: GoogleFonts.montserrat(
              fontSize: 14.sp,
              fontWeight: FontWeight.w900,
              color: Colors.redAccent,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}
