import 'package:evora/core/theme/app_colors.dart';
import 'package:evora/screens/booking/bookings_screen.dart';
import 'package:evora/screens/explore/explore_feed_screen.dart';
import 'package:evora/screens/messages/messages_screen.dart';
import 'package:evora/screens/home/screens/home_screens.dart';
import 'package:evora/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    if (location == ExploreFeedScreen.route) return 1;
    if (location == BookingsScreen.route) return 2;
    if (location == MessagesScreen.route) return 3;
    if (location == ProfileScreen.route) return 4;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(HomeScreens.route);
        break;
      case 1:
        context.go(ExploreFeedScreen.route);
        break;
      case 2:
        context.go(BookingsScreen.route);
        break;
      case 3:
        context.go(MessagesScreen.route);
        break;
      case 4:
        context.go(ProfileScreen.route);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      extendBody: true,
      body: NotificationListener<UserScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.axis == Axis.vertical) {
            if (notification.direction == ScrollDirection.reverse) {
              if (_isVisible) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && _isVisible) setState(() => _isVisible = false);
                });
              }
            } else if (notification.direction == ScrollDirection.forward) {
              if (!_isVisible) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_isVisible) setState(() => _isVisible = true);
                });
              }
            }
          }
          return true;
        },
        child: widget.child,
      ),
      bottomNavigationBar: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: Alignment.bottomCenter,
        child: ClipRect(
          child: SizedBox(
            height: _isVisible ? 75 : 0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutQuart,
              offset: _isVisible ? Offset.zero : const Offset(0, 1.5),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isVisible ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, -5),
                      ),
                    ],
                  ),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final double barWidth = constraints.maxWidth;
                      final double tabWidth = barWidth / 5;
                      const double indicatorWidth = 32;

                      return Stack(
                        children: [
                          AnimatedPositioned(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeOutBack,
                            top: 0,
                            left: (tabWidth * selectedIndex) +
                                (tabWidth / 2) -
                                (indicatorWidth / 2),
                            child: Container(
                              width: indicatorWidth,
                              height: 4,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildNavItem(0, Icons.home_rounded, "Home", selectedIndex),
                              _buildNavItem(1, Icons.explore_rounded, "Explore", selectedIndex),
                              _buildNavItem(2, Icons.calendar_today_rounded, "Bookings", selectedIndex),
                              _buildNavItem(3, Icons.message_rounded, "Messages", selectedIndex),
                              _buildNavItem(4, Icons.person_rounded, "Profile", selectedIndex),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, int selectedIndex) {
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
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
                size: 26,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: isSelected ? AppColors.primaryColor : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
