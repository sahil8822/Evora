import 'package:evora_partner_app/screens/auth/authentication/forgot_password_screen.dart';
import 'package:evora_partner_app/screens/auth/authentication/login_screen.dart';
import 'package:evora_partner_app/screens/auth/authentication/signup_screen.dart';
import 'package:evora_partner_app/screens/auth/onboarding/onboarding_screen.dart';
import 'package:evora_partner_app/screens/auth/onboarding/service_selection_screen.dart';
import 'package:evora_partner_app/screens/auth/onboarding/splash_screen.dart';
import 'package:evora_partner_app/screens/auth/onboarding/vendor_profile_setup_screen.dart';
import 'package:evora_partner_app/screens/booking/booking_details_screen.dart';
import 'package:evora_partner_app/screens/booking/bookings_screen.dart';
import 'package:evora_partner_app/screens/home/bottom_nave/bottom_nav.dart';
import 'package:evora_partner_app/screens/home/screens/home_screens.dart';
import 'package:evora_partner_app/screens/messages/chat_screen.dart';
import 'package:evora_partner_app/screens/messages/messages_screen.dart';
import 'package:evora_partner_app/screens/profile/profile_screen.dart';
import 'package:evora_partner_app/screens/profile/sub_screens/earnings_screen.dart';
import 'package:evora_partner_app/screens/feed/upload_post_screen.dart';
import 'package:evora_partner_app/screens/feed/vendor_analytics_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: SplashScreen.route,
  routes: [
    GoRoute(
      path: SplashScreen.route,
      name: SplashScreen.route,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: OnboardingScreen.route,
      name: OnboardingScreen.route,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: LoginScreen.route,
      name: LoginScreen.route,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: SignupScreen.route,
      name: SignupScreen.route,
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: ForgotPasswordScreen.route,
      name: ForgotPasswordScreen.route,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: ServiceSelectionScreen.route,
      name: ServiceSelectionScreen.route,
      builder: (context, state) => const ServiceSelectionScreen(),
    ),
    GoRoute(
      path: VendorProfileSetupScreen.route,
      name: VendorProfileSetupScreen.route,
      builder: (context, state) => const VendorProfileSetupScreen(),
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

    // Sub pages
    GoRoute(
      path: BookingDetailsScreen.route,
      name: BookingDetailsScreen.route,
      builder: (context, state) {
        final booking = state.extra as Map<String, dynamic>;
        return BookingDetailsScreen(booking: booking);
      },
    ),
    GoRoute(
      path: ChatScreen.route,
      name: ChatScreen.route,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ChatScreen(name: extra['name'], imageUrl: extra['imageUrl']);
      },
    ),
    GoRoute(
      path: EarningsScreen.route,
      name: EarningsScreen.route,
      builder: (context, state) => const EarningsScreen(),
    ),
    GoRoute(
      path: UploadPostScreen.route,
      name: UploadPostScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const UploadPostScreen(),
    ),
    GoRoute(
      path: VendorAnalyticsScreen.route,
      name: VendorAnalyticsScreen.route,
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const VendorAnalyticsScreen(),
    ),
  ],
);
