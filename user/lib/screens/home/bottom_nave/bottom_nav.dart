import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/booking/bookings_screen.dart';
import 'package:evora/screens/messages/messages_screen.dart';
import 'package:evora/screens/home/screens/home_screens.dart';
import 'package:evora/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNav extends StatefulWidget {
  final Widget child;
  const BottomNav({super.key, required this.child});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav>
    with SingleTickerProviderStateMixin {
  bool _isVisible = true;

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location == HomeScreens.route) return 0;
    if (location == BookingsScreen.route) return 1;
    if (location == MessagesScreen.route) return 2;
    if (location == ProfileScreen.route) return 3;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(HomeScreens.route);
        break;
      case 1:
        context.go(BookingsScreen.route);
        break;
      case 2:
        context.go(MessagesScreen.route);
        break;
      case 3:
        context.go(ProfileScreen.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          // Only respond to vertical scrolling to prevent horizontal swipes from hiding the bar
          if (notification.metrics.axis == Axis.vertical) {
            if (notification.direction == ScrollDirection.reverse) {
              if (_isVisible) setState(() => _isVisible = false);
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_isVisible) setState(() => _isVisible = true);
            }
          }
          return true;
        },
        child: widget.child,
      ),
      extendBody: true,
      bottomNavigationBar: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutQuart,
        offset: _isVisible ? Offset.zero : const Offset(0, 1.5),
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: _isVisible ? 1 : 0,
          child: Container(
            height: 75.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20.r,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final double barWidth = constraints.maxWidth;
                final double tabWidth = barWidth / 4;
                final double indicatorWidth = 32.w;

                return Stack(
                  children: [
                    // Precision Sliding Indicator (Top)
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutBack,
                      top: 0,
                      left:
                          (tabWidth * selectedIndex) +
                          (tabWidth / 2) -
                          (indicatorWidth / 2),
                      child: Container(
                        width: indicatorWidth,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildNavItem(
                          0,
                          Icons.home_rounded,
                          "Home",
                          selectedIndex,
                        ),
                        _buildNavItem(
                          1,
                          Icons.calendar_today_rounded,
                          "Bookings",
                          selectedIndex,
                        ),
                        _buildNavItem(
                          2,
                          Icons.message_rounded,
                          "Messages",
                          selectedIndex,
                        ),
                        _buildNavItem(
                          3,
                          Icons.person_rounded,
                          "Profile",
                          selectedIndex,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
    int index,
    IconData icon,
    String label,
    int selectedIndex,
  ) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onItemTapped(index, context),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.grey.shade400,
                size: 26.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected
                    ? AppColors.primaryColor
                    : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
