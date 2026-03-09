import 'package:cached_network_image/cached_network_image.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/profile/sub_screens/earnings_screen.dart';
import 'package:evora_partner_app/screens/auth/authentication/login_screen.dart';
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
        slivers: [
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.primaryColor,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 40.h),
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 40.r,
                          backgroundColor: Colors.white,
                          backgroundImage: const CachedNetworkImageProvider(
                            'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=200',
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        "Royal Tent House",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Premium Vendor",
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection("Business Management"),
                  _buildProfileTile(
                    Icons.info_outline,
                    "Business Information",
                    "Edit details, location, and description",
                    () {},
                  ),
                  _buildProfileTile(
                    Icons.design_services_outlined,
                    "Services Offered",
                    "Manage your service packages",
                    () {},
                  ),
                  _buildProfileTile(
                    Icons.photo_library_outlined,
                    "Portfolio Gallery",
                    "Update your work photos",
                    () {},
                  ),
                  SizedBox(height: 16.h),
                  _buildPortfolioSection(),
                  SizedBox(height: 24.h),
                  _buildSection("Financials"),
                  _buildProfileTile(
                    Icons.payments_outlined,
                    "Earnings & Payouts",
                    "Check your balance and reports",
                    () => context.push(EarningsScreen.route),
                  ),
                  _buildProfileTile(
                    Icons.account_balance_wallet_outlined,
                    "Bank Account",
                    "Manage withdrawal methods",
                    () {},
                  ),
                  SizedBox(height: 24.h),
                  _buildSection("Support & Legal"),
                  _buildProfileTile(
                    Icons.help_outline,
                    "Help Center",
                    "FAQs and contact support",
                    () {},
                  ),
                  _buildProfileTile(
                    Icons.policy_outlined,
                    "Terms & Privacy",
                    "Read our legal documents",
                    () {},
                  ),
                  SizedBox(height: 40.h),
                  ElevatedButton(
                    onPressed: () => context.go(LoginScreen.route),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor.withOpacity(0.1),
                      foregroundColor: AppColors.errorColor,
                      elevation: 0,
                      minimumSize: Size(double.infinity, 56.h),
                    ),
                    child: const Text("Logout"),
                  ),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.secondaryColor,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildProfileTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: AppColors.accentColor, size: 24.sp),
        ),
        title: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14.sp,
          ),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: AppColors.textSecondary,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.sp,
          color: AppColors.secondaryColor,
        ),
      ),
    );
  }

  Widget _buildPortfolioSection() {
    final images = [
      'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?q=80&w=200',
      'https://images.unsplash.com/photo-1464366420604-1730ce71e4ad?q=80&w=200',
      'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?q=80&w=200',
      'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=200',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            "Recent Work",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          height: 80.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: images.length,
            separatorBuilder: (_, __) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              return Container(
                width: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(images[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
