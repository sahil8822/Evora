import 'package:flutter/material.dart';
import 'package:evora/screens/auth/onboarding/onboarding_screen.dart';
import 'package:evora/screens/home/bottom_nav/bottom_nav.dart';
import 'package:evora/screens/booking/bookings_screen.dart';
import 'package:evora/screens/home/screens/home_screens.dart';
import 'package:evora/screens/profile/profile_screen.dart';
import 'package:evora/screens/messages/messages_screen.dart';
import 'package:evora/screens/services/vendor_listing_screen.dart';
import 'package:evora/screens/services/vendor_details_screen.dart';
import 'package:evora/screens/services/booking_wizard.dart';
import 'package:evora/screens/services/payment_screen.dart';
import 'package:evora/screens/services/booking_confirmation_screen.dart';
import 'package:evora/screens/messages/chat_screen.dart';
import 'package:evora/screens/explore/explore_feed_screen.dart';
import 'package:evora/screens/home/screens/search_screen.dart';

import 'package:evora/screens/booking/booking_details_screen.dart';
import 'package:evora/screens/services/all_reviews_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:evora/screens/auth/onboarding/splash_screen.dart';
import 'package:evora/screens/auth/authentication/login_screen.dart';
import 'package:evora/screens/auth/authentication/signup_screen.dart';
import 'package:evora/screens/auth/authentication/forgot_password_screen.dart';
import 'package:evora/screens/profile/sub_screens/personal_info_screen.dart';
import 'package:evora/screens/profile/sub_screens/saved_vendors_screen.dart';
import 'package:evora/screens/profile/sub_screens/my_reviews_screen.dart';
import 'package:evora/screens/profile/sub_screens/payment_history_screen.dart';
import 'package:evora/screens/profile/sub_screens/notifications_settings_screen.dart';
import 'package:evora/screens/profile/sub_screens/security_screen.dart';
import 'package:evora/screens/profile/sub_screens/help_center_screen.dart';
import 'package:evora/screens/profile/sub_screens/about_screen.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// App router configuration using GoRouter
final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: SplashScreen.route,
  routes: [
    GoRoute(
      path: SplashScreen.route,
      name: SplashScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardingScreen.route,
      name: OnboardingScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: LoginScreen.route,
      name: LoginScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignupScreen.route,
      name: SignupScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: ForgotPasswordScreen.route,
      name: ForgotPasswordScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    /// ShellRoute for Bottom Navigation
    ShellRoute(
      builder: (context, state, child) => BottomNav(child: child),
      routes: [
        GoRoute(
          path: HomeScreens.route,
          name: HomeScreens.route,
          builder: (context, state) => const HomeScreens(),
        ),
        GoRoute(
          path: ExploreFeedScreen.route,
          name: ExploreFeedScreen.route,
          builder: (context, state) => const ExploreFeedScreen(),
        ),
        GoRoute(
          path: BookingsScreen.route,
          name: BookingsScreen.route,
          builder: (context, state) => const BookingsScreen(),
        ),
        GoRoute(
          path: MessagesScreen.route,
          name: MessagesScreen.route,
          builder: (context, state) => const MessagesScreen(),
        ),
        GoRoute(
          path: ProfileScreen.route,
          name: ProfileScreen.route,
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),

    // Top-level routes that should NOT show the bottom navigation bar
    GoRoute(
      path: ChatScreen.route,
      name: ChatScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        final map = extra is Map<String, dynamic> ? extra : const <String, dynamic>{};
        final name = (map['name'] as String?) ?? 'Chat';
        final imageUrl = (map['imageUrl'] as String?) ?? '';
        return ChatScreen(name: name, imageUrl: imageUrl);
      },
    ),
    GoRoute(
      path: VendorListingScreen.route,
      name: VendorListingScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final categoryName = state.extra as String? ?? 'Services';
        return VendorListingScreen(categoryName: categoryName);
      },
    ),
    GoRoute(
      path: VendorDetailsScreen.route,
      name: VendorDetailsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const VendorDetailsScreen(),
    ),
    GoRoute(
      path: BookingWizard.route,
      name: BookingWizard.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BookingWizard(),
    ),
    GoRoute(
      path: PaymentScreen.route,
      name: PaymentScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PaymentScreen(),
    ),
    GoRoute(
      path: BookingConfirmationScreen.route,
      name: BookingConfirmationScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const BookingConfirmationScreen(),
    ),
    GoRoute(
      path: SearchScreen.route,
      name: SearchScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SearchScreen(),
    ),
    GoRoute(
      path: PersonalInfoScreen.route,
      name: PersonalInfoScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PersonalInfoScreen(),
    ),
    GoRoute(
      path: SavedVendorsScreen.route,
      name: SavedVendorsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SavedVendorsScreen(),
    ),
    GoRoute(
      path: MyReviewsScreen.route,
      name: MyReviewsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const MyReviewsScreen(),
    ),
    GoRoute(
      path: PaymentHistoryScreen.route,
      name: PaymentHistoryScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PaymentHistoryScreen(),
    ),
    GoRoute(
      path: NotificationsSettingsScreen.route,
      name: NotificationsSettingsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const NotificationsSettingsScreen(),
    ),
    GoRoute(
      path: SecurityScreen.route,
      name: SecurityScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SecurityScreen(),
    ),
    GoRoute(
      path: HelpCenterScreen.route,
      name: HelpCenterScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const HelpCenterScreen(),
    ),
    GoRoute(
      path: AboutScreen.route,
      name: AboutScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AboutScreen(),
    ),
    GoRoute(
      path: BookingDetailsScreen.route,
      name: BookingDetailsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra;
        final booking =
            extra is Map<String, dynamic> ? extra : <String, dynamic>{};
        return BookingDetailsScreen(booking: booking);
      },
    ),
    GoRoute(
      path: AllReviewsScreen.route,
      name: AllReviewsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const AllReviewsScreen(),
    ),
  ],
);
