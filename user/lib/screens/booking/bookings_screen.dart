import 'package:cached_network_image/cached_network_image.dart';
import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/booking/booking_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});
  static const String route = '/bookings';

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> {
  String _selectedStatus = 'Upcoming';

  void _onStatusChange(String status) {
    setState(() {
      _selectedStatus = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          // Minimalist Modern Header
          _buildHeader(context),

          // Sleek Status Selection (Modern & Light)
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
            child: Row(
              children: [
                _buildSleekStatusItem('Upcoming', '12', Colors.blueAccent),
                SizedBox(width: 15.w),
                _buildSleekStatusItem('History', '45', Colors.green.shade600),
                SizedBox(width: 15.w),
                _buildSleekStatusItem('Cancelled', '03', Colors.redAccent),
              ],
            ),
          ),

          // Filtered Listing
          Expanded(
            child: _BookingList(
              status: _selectedStatus,
              key: ValueKey(_selectedStatus),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 16.h),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Bookings',
                style: GoogleFonts.montserrat(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Manage your reservations',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSleekStatusItem(String status, String count, Color accentColor) {
    final bool isSelected = _selectedStatus == status;

    return Expanded(
      child: GestureDetector(
        onTap: () => _onStatusChange(status),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
            ],
            border: Border.all(
              color: isSelected
                  ? accentColor.withOpacity(0.4)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                count,
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? accentColor
                      : AppColors.textPrimary.withOpacity(0.6),
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                status,
                style: GoogleFonts.poppins(
                  fontSize: 11.sp,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? accentColor : AppColors.textSecondary,
                ),
              ),
              if (isSelected)
                Container(
                  margin: EdgeInsets.only(top: 8.h),
                  height: 3.h,
                  width: 12.w,
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final String status;
  const _BookingList({required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 100.h),
      physics: const BouncingScrollPhysics(),
      itemCount: status == 'Cancelled' ? 0 : (status == 'Upcoming' ? 2 : 5),
      itemBuilder: (context, index) {
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + (index * 80)),
          curve: Curves.easeOutQuart,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 15 * (1 - value)),
                child: child,
              ),
            );
          },
          child: _ModernBookingCard(index: index, status: status),
        );
      },
    );
  }
}

class _ModernBookingCard extends StatelessWidget {
  final int index;
  final String status;
  const _ModernBookingCard({required this.index, required this.status});

  @override
  Widget build(BuildContext context) {
    final bool isUpcoming = status == 'Upcoming';
    final Color statusColor = status == 'Upcoming'
        ? Colors.blueAccent
        : (status == 'History' ? Colors.green.shade600 : Colors.redAccent);

    return Container(
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(14.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.r),
                  child: CachedNetworkImage(
                    imageUrl: _getDummyImage(index),
                    width: 60.w,
                    height: 60.w,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey.shade100,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _getCategory(index).toUpperCase(),
                            style: GoogleFonts.poppins(
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                              color: statusColor.withOpacity(0.8),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            '#BK-${2045 + index}',
                            style: GoogleFonts.poppins(
                              fontSize: 10.sp,
                              color: AppColors.textSecondary.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _getVendorName(index),
                        style: GoogleFonts.montserrat(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        '24 Oct, 2024 • 10:30 AM',
                        style: GoogleFonts.poppins(
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.03),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(24.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle_outline_rounded,
                      size: 14.sp,
                      color: statusColor,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      status,
                      style: GoogleFonts.poppins(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${(index + 1) * 12000 + 5000}',
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          if (isUpcoming)
            Padding(
              padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 14.h),
              child: Row(
                children: [
                  Expanded(child: _buildSmallActionBtn('Track Status', false)),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: _buildSmallActionBtn(
                      'Details',
                      true,
                      onTap: () => context.push(
                        BookingDetailsScreen.route,
                        extra: {
                          'name': _getVendorName(index),
                          'imageUrl': _getDummyImage(index),
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSmallActionBtn(
    String label,
    bool isPrimary, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isPrimary
                ? AppColors.primaryColor
                : Colors.grey.withOpacity(0.15),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12.sp,
            fontWeight: isPrimary ? FontWeight.w700 : FontWeight.w500,
            color: isPrimary ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _getDummyImage(int index) {
    final List<String> images = [
      'https://images.unsplash.com/photo-1519167758481-83f550bb49b3?auto=format&fit=crop&q=80&w=200',
      'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&q=80&w=200',
      'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&q=80&w=200',
      'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?auto=format&fit=crop&q=80&w=200',
    ];
    return images[index % images.length];
  }

  String _getVendorName(int index) {
    final List<String> names = [
      'Royal Palace Grand Marquee',
      'Euphoria Lighting & Sound',
      'Saffron Gourmet Catering',
      'Starlight Photo & Cinema',
    ];
    return names[index % names.length];
  }

  String _getCategory(int index) {
    final List<String> cats = ['Venue', 'Lighting', 'Catering', 'Photography'];
    return cats[index % cats.length];
  }
}
