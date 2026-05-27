import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/home/widgets/home_header.dart';
import 'package:evora/screens/home/widgets/home_search_bar.dart';
import 'package:evora/screens/home/widgets/promo_banner.dart';
import 'package:evora/screens/home/widgets/service_grid.dart';
import 'package:evora/screens/home/widgets/trending_services.dart';
import 'package:evora/screens/home/widgets/event_package_card.dart';
import 'package:evora/screens/home/widgets/vendor_card.dart';
import 'package:evora/screens/home/widgets/special_offers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});
  static const String route = '/home';

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Pinned Header
          SliverAppBar(
            expandedHeight: 80.h,
            collapsedHeight: 80.h,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.backgroundColor,
            surfaceTintColor: AppColors.backgroundColor,
            flexibleSpace: const FlexibleSpaceBar(background: HomeHeader()),
          ),

          // Search Bar & Promo Banner (Scrollable)
          SliverToBoxAdapter(
            child: Column(
              children: [
                HomeSearchBar(controller: _searchController),
                SizedBox(height: 12.h),
                const PromoBanner(),
              ],
            ),
          ),

          // Service Category Grid
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: const ServiceGrid(),
            ),
          ),

          // Trending Services
          const SliverToBoxAdapter(child: TrendingServices()),

          // Event Packages Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Planning an Event?',
                      style: GoogleFonts.montserrat(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        EventPackageCard(
                          title: 'Wedding Magic',
                          subtitle: 'Full-service wedding planning',
                          price: '₹2,50,000',
                          color: AppColors.primaryColor,
                          icon: Icons.favorite_rounded,
                        ),
                        EventPackageCard(
                          title: 'Corp Events',
                          subtitle: 'Conferences & Annual Meets',
                          price: '₹50,000',
                          color: AppColors.accentColor,
                          icon: Icons.business_center_rounded,
                        ),
                        EventPackageCard(
                          title: 'Birthday Bash',
                          subtitle: 'Theme parties for all ages',
                          price: '₹15,000',
                          color: const Color(0xFF7CB6B9),
                          icon: Icons.cake_rounded,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Special Offers
          const SliverToBoxAdapter(child: SpecialOffers()),

          // Vendors Near You Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 32.h, 20.w, 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Vendors Near You',
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Vendor List
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const VendorCard(
                  name: 'The Royal Tent House',
                  category: 'Tent House',
                  price: '₹15,000',
                  rating: 4.8,
                  distance: '2.4 km away',
                  imageUrl:
                      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&q=80&w=400',
                ),
                const VendorCard(
                  name: 'Shree Catering Services',
                  category: 'Catering',
                  price: '₹500/plate',
                  rating: 4.9,
                  distance: '1.2 km away',
                  imageUrl:
                      'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&q=80&w=400',
                ),
                const VendorCard(
                  name: 'Milan Wedding Garden',
                  category: 'Garden',
                  price: '₹80,000',
                  rating: 4.7,
                  distance: '3.5 km away',
                  imageUrl:
                      'https://images.unsplash.com/photo-1519225421980-715cb0215aed?auto=format&fit=crop&q=80&w=400',
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
