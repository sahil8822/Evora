import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/providers/vendor_provider.dart';
import 'package:evora/screens/home/widgets/vendor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VendorListingScreen extends StatefulWidget {
  final String categoryName;
  const VendorListingScreen({super.key, required this.categoryName});

  static const String route = '/vendor-listing';

  @override
  State<VendorListingScreen> createState() => _VendorListingScreenState();
}

class _VendorListingScreenState extends State<VendorListingScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Always reset state when entering this screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<VendorProvider>(context, listen: false);
      provider
          .clearFilters(); // Reset everything (Sub-filter defaults to 'All')

      // If we came from a specific category on Home, set it as the main category restraint
      if (widget.categoryName != 'Services' && widget.categoryName != 'All') {
        provider.setMainCategory(widget.categoryName);
      }
    });
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final offset = _scrollController.offset;
      if (offset > 50 && !_isCollapsed) {
        setState(() => _isCollapsed = true);
      } else if (offset <= 50 && _isCollapsed) {
        setState(() => _isCollapsed = false);
      }
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Get dynamic sub-categories based on the main category
  List<Map<String, dynamic>> _getDynamicCategories() {
    final mainCat = widget.categoryName.toLowerCase();

    if (mainCat.contains('tent')) {
      return [
        {'name': 'All', 'icon': Icons.grid_view_rounded},
        {'name': 'Royal Tent', 'icon': Icons.temple_hindu_rounded},
        {'name': 'AC Tent', 'icon': Icons.ac_unit_rounded},
        {'name': 'Waterproof', 'icon': Icons.umbrella_rounded},
        {'name': 'Budget Tent', 'icon': Icons.savings_rounded},
      ];
    } else if (mainCat.contains('decor')) {
      return [
        {'name': 'All', 'icon': Icons.grid_view_rounded},
        {'name': 'Flower Decor', 'icon': Icons.local_florist_rounded},
        {'name': 'Theme Decor', 'icon': Icons.style_rounded},
        {'name': 'Stage Decor', 'icon': Icons.event_seat_rounded},
        {'name': 'Entrance', 'icon': Icons.door_front_door_rounded},
      ];
    } else if (mainCat.contains('catering') || mainCat.contains('food')) {
      return [
        {'name': 'All', 'icon': Icons.grid_view_rounded},
        {'name': 'North Indian', 'icon': Icons.restaurant_rounded},
        {'name': 'South Indian', 'icon': Icons.ramen_dining_rounded},
        {'name': 'Chinese', 'icon': Icons.bakery_dining_rounded},
        {'name': 'Continental', 'icon': Icons.flatware_rounded},
      ];
    } else if (mainCat.contains('photo') || mainCat.contains('camera')) {
      return [
        {'name': 'All', 'icon': Icons.grid_view_rounded},
        {'name': 'Candid', 'icon': Icons.camera_rounded},
        {'name': 'Cinematic', 'icon': Icons.movie_rounded},
        {'name': 'Pre-wedding', 'icon': Icons.favorite_rounded},
        {'name': 'Drone', 'icon': Icons.flight_rounded},
      ];
    }

    // Default global categories if no match
    return [
      {'name': 'All', 'icon': Icons.grid_view_rounded},
      {'name': 'Tent House', 'icon': Icons.house_rounded},
      {'name': 'Lighting', 'icon': Icons.light_rounded},
      {'name': 'Catering', 'icon': Icons.restaurant_rounded},
      {'name': 'Photography', 'icon': Icons.camera_alt_rounded},
      {'name': 'DJ', 'icon': Icons.music_note_rounded},
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Consumer<VendorProvider>(
        builder: (context, vendorProvider, child) {
          final vendors = vendorProvider.filteredVendors;
          final dynamicCats = _getDynamicCategories();

          return CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140.h,
                pinned: true,
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                backgroundColor: Colors.white,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.textPrimary,
                    size: 20.sp,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.tune_rounded,
                      color: AppColors.accentColor,
                    ),
                    onPressed: () => _showFilterBottomSheet(vendorProvider),
                  ),
                ],
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _isCollapsed ? 1.0 : 0.0,
                  child: Text(
                    widget.categoryName,
                    style: GoogleFonts.montserrat(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    children: [
                      Positioned(
                        top: 80.h,
                        left: 20.w,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isCollapsed ? 0.0 : 1.0,
                          child: Text(
                            widget.categoryName,
                            style: GoogleFonts.montserrat(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 12.h,
                        left: 16.w,
                        right: 16.w,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _isCollapsed ? 0.0 : 1.0,
                          child: _buildSearchField(vendorProvider),
                        ),
                      ),
                    ],
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(_isCollapsed ? 0 : 30.r),
                  ),
                ),
              ),

              // Dynamic Sub-Category Filter
              SliverToBoxAdapter(
                child: Container(
                  height: 45.h,
                  margin: EdgeInsets.symmetric(vertical: 16.h),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: dynamicCats.length,
                    itemBuilder: (context, index) {
                      final cat = dynamicCats[index];
                      return _buildCategoryChip(
                        cat['name'] as String,
                        cat['icon'] as IconData,
                        vendorProvider,
                      );
                    },
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 4.h,
                        width: 24.w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        '${vendors.length} Premium Vendors',
                        style: GoogleFonts.poppins(
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SliverPadding(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 40.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final vendor = vendors[index];
                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: Duration(milliseconds: 300 + (index * 60)),
                      curve: Curves.easeOutCubic,
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 25 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: VendorCard(
                        name: vendor.name,
                        category: vendor.category,
                        price: vendor.price,
                        rating: vendor.rating,
                        distance: vendor.distance,
                        imageUrl: vendor.imageUrl,
                      ),
                    );
                  }, childCount: vendors.length),
                ),
              ),

              if (vendors.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 70.sp,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No vendors found for this filter',
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSearchField(VendorProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: provider.updateSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search vendors...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 13.sp,
            color: Colors.grey.shade400,
          ),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: AppColors.accentColor,
            size: 20.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.close_rounded,
                    size: 18.sp,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    provider.updateSearchQuery('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(
    String category,
    IconData icon,
    VendorProvider provider,
  ) {
    final isSelected = provider.selectedCategoryFilter == category;
    return GestureDetector(
      onTap: () => provider.updateCategoryFilter(category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(right: 12.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: AppColors.primaryColor.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
          ],
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : Colors.grey.withOpacity(0.1),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18.sp,
              color: isSelected ? Colors.white : AppColors.accentColor,
            ),
            SizedBox(width: 8.w),
            Text(
              category,
              style: GoogleFonts.poppins(
                fontSize: 12.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterBottomSheet(VendorProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
          ),
          padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 40.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Refine Search',
                    style: GoogleFonts.montserrat(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      provider.clearFilters();
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Reset All',
                      style: GoogleFonts.poppins(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),

              _buildSectionTitle('Prefer Location'),
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'e.g. Vidhyadhar Nagar, Jaipur',
                    hintStyle: TextStyle(fontSize: 14.sp),
                    icon: Icon(
                      Icons.location_on_rounded,
                      color: AppColors.primaryColor,
                      size: 20.sp,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (val) => provider.updateFilters(location: val),
                ),
              ),

              SizedBox(height: 30.h),

              _buildSectionTitle('Sort By'),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 10.w,
                runSpacing: 10.h,
                children: [
                  _buildSortChip('Most Popular', true),
                  _buildSortChip('Newest First', false),
                  _buildSortChip('High Rating', false),
                  _buildSortChip('Price: Low to High', false),
                ],
              ),

              SizedBox(height: 30.h),

              _buildSectionTitle('Price Range'),
              SizedBox(height: 4.h),
              RangeSlider(
                values: provider.priceRange,
                min: 1000,
                max: 500000,
                divisions: 100,
                activeColor: AppColors.primaryColor,
                inactiveColor: AppColors.primaryColor.withOpacity(0.1),
                labels: RangeLabels(
                  '₹${provider.priceRange.start.round()}',
                  '₹${provider.priceRange.end.round()}',
                ),
                onChanged: (values) {
                  provider.updateFilters(priceRange: values);
                  setModalState(() {});
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${provider.priceRange.start.round()}',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '₹${provider.priceRange.end.round()}',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    elevation: 5,
                    shadowColor: AppColors.primaryColor.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  child: Text(
                    'Apply Filters',
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.montserrat(
        fontSize: 17.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildSortChip(String label, bool isSelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.accentColor.withOpacity(0.1)
            : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isSelected
              ? AppColors.accentColor
              : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.accentColor : AppColors.textSecondary,
        ),
      ),
    );
  }
}
