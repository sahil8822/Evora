import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/core/utils/entrance_fader.dart';
import 'package:evora/screens/home/screens/search_screen.dart';
import 'package:evora/screens/home/widgets/home_header.dart';
import 'package:evora/screens/home/widgets/promo_banner.dart';
import 'package:evora/screens/home/widgets/service_grid.dart';
import 'package:evora/screens/home/widgets/trending_services.dart';
import 'package:evora/screens/home/widgets/vendor_card.dart';
import 'package:evora/screens/home/widgets/special_offers.dart';
import 'package:evora/screens/home/widgets/home_search_bar.dart';
import 'package:evora/screens/home/widgets/category_tabs.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});
  static const String route = '/home';

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late TabController _tabController;
  Color _currentThemeColor = const Color(0xFFE3F2FD);
  int _selectedCategoryIndex = 0;
  bool _isTransitioning = false;
  double _scrollOpacity = 0.0;

  final List<Color> _categoryColors = const [
    Color(0xFFE3F2FD), // All
    Color(0xFFE1F5FE), // Tent House
    Color(0xFFF3E5F5), // Decoration
    Color(0xFFE8F5E9), // Wedding Garden
    Color(0xFFFFF3E0), // Catering
    Color(0xFFFCE4EC), // DJ
    Color(0xFFE0F2F1), // Cameraman
    Color(0xFFFFF8E1), // Mehendi
    Color(0xFFE8EAF6), // Wedding Cards
    Color(0xFFF5F5F5), // Corporate
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: CategoryTabs.categories.length,
      vsync: this,
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    double offset = _scrollController.offset;
    double opacity = (offset / 100).clamp(0.0, 1.0);
    if (opacity != _scrollOpacity) {
      if (mounted) setState(() => _scrollOpacity = opacity);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(int index) {
    if (_selectedCategoryIndex == index) return;
    setState(() {
      _isTransitioning = true;
      _selectedCategoryIndex = index;
      _currentThemeColor = _categoryColors[index];
    });
    _tabController.animateTo(index);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) setState(() => _isTransitioning = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Stack(
        children: [
          // Dynamic Background Gradient
          AnimatedContainer(
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInCubic,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  _currentThemeColor.withOpacity(0.4),
                  AppColors.backgroundColor,
                  _currentThemeColor.withOpacity(0.1),
                ],
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),

          // Content
          GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Custom Persistent Header
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _HomeHeaderDelegate(
                    searchController: _searchController,
                    tabController: _tabController,
                    onCategoryChanged: _onCategoryChanged,
                    currentThemeColor: _currentThemeColor,
                    scrollOpacity: _scrollOpacity,
                  ),
                ),

                // Dynamic Body Content
                SliverToBoxAdapter(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutCubic,
                    layoutBuilder: (child, List<Widget> previousChildren) {
                      return Stack(
                        children: [
                          ...previousChildren,
                          if (child != null) child,
                        ],
                      );
                    },
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: _isTransitioning
                        ? _buildSkeletonLoading()
                        : _buildCategoryContent(),
                  ),
                ),

                // Bottom Spacing
                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonLoading() {
    return Container(
      key: const ValueKey('loading_skeleton'),
      height: 400,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(
              3,
              (i) => Expanded(
                child: Container(
                  height: 100,
                  margin: EdgeInsets.only(right: i < 2 ? 12 : 0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryContent() {
    if (_selectedCategoryIndex == 0) {
      return Column(
        key: const ValueKey('all_category'),
        children: [
          const EntranceFader(child: PromoBanner()),
          _buildQuickActionChips(),
          _buildSectionHeader('Special Features', showViewAll: true),
          _buildFeatureHighlights(),
          const TrendingServices(),
          const ServiceGrid(),
          const SpecialOffers(),
          _buildVendorSection('Popular Near You'),
        ],
      );
    }

    return Column(
      key: ValueKey('category_$_selectedCategoryIndex'),
      children: [
        _buildCategoryHero(_getCategoryName(_selectedCategoryIndex)),
        _buildVendorSection('Best ${_getCategoryName(_selectedCategoryIndex)}'),
      ],
    );
  }

  Widget _buildQuickActionChips() {
    final chips = ['✨ Near You', '🏆 Top Rated', '🔥 Deals'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: chips
            .map(
              (label) => Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {bool showViewAll = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (showViewAll)
            Text(
              'View All',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCategoryHero(String name) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _currentThemeColor,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(colors: [_currentThemeColor, Colors.white]),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(24),
      child: Text(
        name,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildFeatureHighlights() {
    return SizedBox(
      height: 160,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildFeatureCard(
            'Luxury Decor',
            'Premium Styling',
            'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=300',
          ),
          _buildFeatureCard(
            'Grand Catering',
            'Elite Chefs',
            'https://images.unsplash.com/photo-1555244162-803834f70033?auto=format&fit=crop&q=80&w=300',
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(String title, String sub, String img) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              img,
              height: 100,
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  sub,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVendorSection(String title) {
    return Column(
      children: [
        _buildSectionHeader(title),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: VendorCard(
            name: 'Royal Heritage Plaza',
            category: 'Luxury Garden',
            price: '₹45,000',
            rating: 4.9,
            distance: '2.4 km',
            imageUrl:
                'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=500',
          ),
        ),
      ],
    );
  }

  String _getCategoryName(int i) => CategoryTabs.categories[i]['name'];
}

class _HomeHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TextEditingController searchController;
  final TabController tabController;
  final Function(int) onCategoryChanged;
  final Color currentThemeColor;
  final double scrollOpacity;

  _HomeHeaderDelegate({
    required this.searchController,
    required this.tabController,
    required this.onCategoryChanged,
    required this.currentThemeColor,
    required this.scrollOpacity,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final topPadding = MediaQuery.of(context).padding.top;
    final progress = (shrinkOffset / maxExtent).clamp(0.0, 1.0);
    final currentPadding = topPadding * progress;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(progress),
        boxShadow: progress > 0.8
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Column(
        children: [
          // Collapsible Header (Greeting & Location)
          Opacity(
            opacity: (1 - (progress * 1.5)).clamp(0.0, 1.0),
            child: SizedBox(
              height: (1 - progress) * 105,
              child: const Padding(
                padding: EdgeInsets.only(top: 10),
                child: HomeHeader(),
              ),
            ),
          ),
          // Fixed Elements (Search Bar & Tabs)
          Padding(
            padding: EdgeInsets.only(top: currentPadding + 8),
            child: Column(
              children: [
                HomeSearchBar(
                  controller: searchController,
                  onTap: () => context.push(SearchScreen.route),
                ),
                CategoryTabs(
                  controller: tabController,
                  onCategorySelected: onCategoryChanged,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 285;
  @override
  double get minExtent => 155;
  @override
  bool shouldRebuild(covariant _HomeHeaderDelegate old) =>
      old.scrollOpacity != scrollOpacity ||
      old.currentThemeColor != currentThemeColor ||
      old.tabController != tabController;
}
