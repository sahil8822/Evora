import 'package:evora_partner_app/components/app_text.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/services/vendor_listing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

// --- Dummy Data ---
class _ServiceCategory {
  final String name;
  final IconData icon;
  final Color color;
  final String description;
  final String priceRange;
  final int vendors;

  const _ServiceCategory({
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
    required this.priceRange,
    required this.vendors,
  });
}

const List<_ServiceCategory> _categories = [
  _ServiceCategory(
    name: 'Tent House',
    icon: Icons.house_rounded,
    color: Color(0xFFE8D5CC),
    description: 'Premium tents, pandals & shamiana setups',
    priceRange: '₹15,000 – ₹2,00,000',
    vendors: 42,
  ),
  _ServiceCategory(
    name: 'Lighting & Decor',
    icon: Icons.lightbulb_rounded,
    color: Color(0xFFFFF3CD),
    description: 'LED lighting, stage decoration & flower setups',
    priceRange: '₹8,000 – ₹1,50,000',
    vendors: 38,
  ),
  _ServiceCategory(
    name: 'Mehandi',
    icon: Icons.front_hand_rounded,
    color: Color(0xFFD4EDDA),
    description: 'Traditional bridal & guest mehandi artists',
    priceRange: '₹3,000 – ₹25,000',
    vendors: 27,
  ),
  _ServiceCategory(
    name: 'Wedding Cards',
    icon: Icons.mail_rounded,
    color: Color(0xFFD6D5F0),
    description: 'Custom printed & digital wedding invitations',
    priceRange: '₹2,000 – ₹50,000',
    vendors: 19,
  ),
  _ServiceCategory(
    name: 'DJ & Music',
    icon: Icons.music_note_rounded,
    color: Color(0xFFCCE5FF),
    description: 'DJ systems, live bands & sound setup',
    priceRange: '₹12,000 – ₹1,00,000',
    vendors: 31,
  ),
  _ServiceCategory(
    name: 'Wedding Venues',
    icon: Icons.location_city_rounded,
    color: Color(0xFFF5D5D5),
    description: 'Gardens, banquet halls & farmhouses',
    priceRange: '₹50,000 – ₹10,00,000',
    vendors: 56,
  ),
  _ServiceCategory(
    name: 'Corporate Events',
    icon: Icons.business_center_rounded,
    color: Color(0xFFD5E8D4),
    description: 'Conferences, team outings & annual meets',
    priceRange: '₹25,000 – ₹5,00,000',
    vendors: 15,
  ),
  _ServiceCategory(
    name: 'Catering',
    icon: Icons.restaurant_rounded,
    color: Color(0xFFFFE0CC),
    description: 'Multi-cuisine food & beverage service',
    priceRange: '₹300 – ₹2,000/plate',
    vendors: 48,
  ),
  _ServiceCategory(
    name: 'Photography',
    icon: Icons.camera_alt_rounded,
    color: Color(0xFFE0D5F5),
    description: 'Photo, video, drone & candid coverage',
    priceRange: '₹10,000 – ₹3,00,000',
    vendors: 63,
  ),
];

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});
  static const String route = '/services';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120.h,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.backgroundColor,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
              title: Text(
                'Explore Services',
                style: GoogleFonts.montserrat(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              background: Container(color: AppColors.backgroundColor),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: AppText(
                  text:
                      'Find the best vendors for your perfect event celebration.',
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                final cat = _categories[index];
                return _ServiceCategoryCard(cat: cat);
              }, childCount: _categories.length),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 100.h)),
        ],
      ),
    );
  }
}

class _ServiceCategoryCard extends StatelessWidget {
  final _ServiceCategory cat;
  const _ServiceCategoryCard({required this.cat});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(VendorListingScreen.route, extra: cat.name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15.r,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cat.color.withOpacity(0.3),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Icon(
                  cat.icon,
                  size: 40.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${cat.vendors} Vendors',
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: AppColors.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

