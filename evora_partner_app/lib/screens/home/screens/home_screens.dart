import 'package:cached_network_image/cached_network_image.dart';
import 'package:evora_partner_app/core/theme/app_colors.dart';
import 'package:evora_partner_app/screens/home/widgets/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});
  static const String route = '/home';

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  /// Creates a staggered entrance animation for a specific index
  Animation<double> _staggeredFade(int index) {
    final start = (index * 0.1).clamp(0.0, 0.7);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: _entranceController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _staggeredSlide(int index) {
    final start = (index * 0.1).clamp(0.0, 0.7);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      ),
    );
  }

  Animation<double> _staggeredScale(int index) {
    final start = (index * 0.1).clamp(0.0, 0.7);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            // ─── Header ───
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _staggeredFade(0),
                child: SlideTransition(
                  position: _staggeredSlide(0),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
                    child: const HomeHeader(),
                  ),
                ),
              ),
            ),

            // ─── Gradient Hero Banner ───
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _staggeredFade(1),
                child: SlideTransition(
                  position: _staggeredSlide(1),
                  child: _buildHeroBanner(),
                ),
              ),
            ),

            // ─── Summary Stats ───
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _staggeredFade(2),
                child: ScaleTransition(
                  scale: _staggeredScale(2),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 0),
                    child: _buildStatCards(),
                  ),
                ),
              ),
            ),

            // ─── Quick Actions ───
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _staggeredFade(3),
                child: SlideTransition(
                  position: _staggeredSlide(3),
                  child: Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: _buildQuickActions(),
                  ),
                ),
              ),
            ),

            // ─── Active Services ───
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _staggeredFade(4),
                child: SlideTransition(
                  position: _staggeredSlide(4),
                  child: Padding(
                    padding: EdgeInsets.only(top: 32.h),
                    child: _buildActiveServices(),
                  ),
                ),
              ),
            ),

            // ─── Today's Bookings Header ───
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _staggeredFade(5),
                child: SlideTransition(
                  position: _staggeredSlide(5),
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 32.h, 24.w, 16.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Today's Schedule",
                          style: GoogleFonts.montserrat(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            "View All",
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // ─── Booking Timeline Cards ───
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return FadeTransition(
                  opacity: _staggeredFade(6 + index),
                  child: SlideTransition(
                    position: _staggeredSlide(6 + index),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 6.h,
                      ),
                      child: _buildTimelineBookingCard(index),
                    ),
                  ),
                );
              }, childCount: 3),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 130.h)),
          ],
        ),
      ),
    );
  }

  // ───────────── HERO BANNER ─────────────
  Widget _buildHeroBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor.withOpacity(0.8),
            AppColors.accentColor.withOpacity(0.7),
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                "Today's Earnings",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.trending_up_rounded,
                      color: AppColors.successColor,
                      size: 14.sp,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      "+12%",
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.successColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            "₹12,450",
            style: GoogleFonts.montserrat(
              fontSize: 36.sp,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20.h),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          SizedBox(height: 20.h),
          Row(
            children: [
              _buildBannerStat("Completed", "08"),
              SizedBox(width: 32.w),
              _buildBannerStat("Upcoming", "03"),
              SizedBox(width: 32.w),
              _buildBannerStat("Cancelled", "01"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBannerStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: GoogleFonts.montserrat(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 11.sp,
            color: Colors.white.withOpacity(0.65),
          ),
        ),
      ],
    );
  }

  // ───────────── STAT CARDS ─────────────
  Widget _buildStatCards() {
    final stats = [
      _StatItem(
        "Total Earnings",
        "₹4,82,500",
        Icons.account_balance_wallet_rounded,
        AppColors.successColor,
      ),
      _StatItem("Active Jobs", "12", Icons.work_rounded, AppColors.accentColor),
      _StatItem(
        "Pending",
        "05",
        Icons.hourglass_top_rounded,
        AppColors.warningColor,
      ),
      _StatItem("Rating", "4.8 ★", Icons.star_rounded, Colors.amber),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.7,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: AnimatedScale(
            duration: const Duration(milliseconds: 200),
            scale: 1.0,
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: const Color(0xFFF2F4F7)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: stat.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(stat.icon, color: stat.color, size: 20.sp),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stat.value,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.montserrat(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        stat.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ───────────── QUICK ACTIONS ─────────────
  Widget _buildQuickActions() {
    final actions = [
      _ActionItem(
        "Add\nService",
        Icons.add_business_rounded,
        AppColors.accentColor,
      ),
      _ActionItem(
        "View\nBookings",
        Icons.calendar_today_rounded,
        AppColors.successColor,
      ),
      _ActionItem(
        "Business\nInsights",
        Icons.bar_chart_rounded,
        AppColors.warningColor,
      ),
      _ActionItem(
        "Contact\nSupport",
        Icons.headset_mic_rounded,
        const Color(0xFF9B59B6),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            "Quick Actions",
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return Container(
                width: 100.w,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: action.color.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: action.color.withOpacity(0.15)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: action.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        action.icon,
                        color: action.color,
                        size: 22.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      action.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────────── ACTIVE SERVICES ─────────────
  Widget _buildActiveServices() {
    final services = [
      _ServicePerf("Tent House", "23 bookings", 0.85, AppColors.accentColor),
      _ServicePerf("Catering", "18 bookings", 0.70, AppColors.successColor),
      _ServicePerf("DJ", "12 bookings", 0.55, AppColors.warningColor),
      _ServicePerf("Photography", "9 bookings", 0.40, const Color(0xFF9B59B6)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            "Service Performance",
            style: GoogleFonts.montserrat(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 120.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            separatorBuilder: (_, __) => SizedBox(width: 14.w),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final s = services[index];
              return Container(
                width: 160.w,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: const Color(0xFFF2F4F7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40.h,
                      width: double.infinity,
                      margin: EdgeInsets.only(bottom: 12.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                            index == 0
                                ? 'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?q=80&w=200'
                                : index == 1
                                ? 'https://images.unsplash.com/photo-1555244162-803834f70033?q=80&w=200'
                                : 'https://images.unsplash.com/photo-1470225620780-dba8ba36b745?q=80&w=200',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      s.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      s.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4.r),
                      child: LinearProgressIndicator(
                        value: s.progress,
                        backgroundColor: s.color.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation(s.color),
                        minHeight: 6.h,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ───────────── BOOKING TIMELINE CARD ─────────────
  Widget _buildTimelineBookingCard(int index) {
    final bookings = [
      _BookingData(
        "Sahil Mansuri",
        "Tent House Setup",
        "06:00 PM",
        "VD Nagar, Jaipur",
        "₹15,000",
        "Confirmed",
        AppColors.successColor,
      ),
      _BookingData(
        "Priya Sharma",
        "Lighting & Decor",
        "08:00 PM",
        "Malviya Nagar, Jaipur",
        "₹22,000",
        "In Progress",
        AppColors.accentColor,
      ),
      _BookingData(
        "Rahul Jain",
        "DJ & Sound",
        "09:30 PM",
        "Mansarovar, Jaipur",
        "₹18,500",
        "Pending",
        AppColors.warningColor,
      ),
    ];
    final b = bookings[index];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF2F4F7)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Status stripe
            Container(
              width: 52.w,
              height: 52.w,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    index == 0
                        ? 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=150'
                        : index == 1
                        ? 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150'
                        : 'https://images.unsplash.com/photo-1599566150163-29194dcaad36?q=80&w=150',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 14.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 14.sp,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: b.statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          b.status,
                          style: GoogleFonts.poppins(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            color: b.statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    b.service,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      _buildMiniTag(Icons.access_time_rounded, b.time),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: _buildMiniTag(
                          Icons.location_on_rounded,
                          b.location,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        b.price,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w800,
                          fontSize: 16.sp,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      Row(
                        children: [
                          _buildSmallAction(
                            Icons.call_rounded,
                            AppColors.successColor,
                          ),
                          SizedBox(width: 8.w),
                          _buildSmallAction(
                            Icons.chat_bubble_outline_rounded,
                            AppColors.accentColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniTag(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13.sp, color: AppColors.textTertiary),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 11.sp,
              color: AppColors.textSecondary,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallAction(IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 16.sp, color: color),
    );
  }
}

// ─── Data Classes ───

class _StatItem {
  final String title, value;
  final IconData icon;
  final Color color;
  _StatItem(this.title, this.value, this.icon, this.color);
}

class _ActionItem {
  final String title;
  final IconData icon;
  final Color color;
  _ActionItem(this.title, this.icon, this.color);
}

class _ServicePerf {
  final String name, subtitle;
  final double progress;
  final Color color;
  _ServicePerf(this.name, this.subtitle, this.progress, this.color);
}

class _BookingData {
  final String name, service, time, location, price, status;
  final Color statusColor;
  _BookingData(
    this.name,
    this.service,
    this.time,
    this.location,
    this.price,
    this.status,
    this.statusColor,
  );
}
