import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/phone_auth_screen.dart';
import '../screens/auth/otp_verification_screen.dart';
import '../screens/auth/account_type_selection_screen.dart';
import '../screens/auth/profile_setup_screen.dart';
import '../screens/home/home_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/phone-auth',
      name: 'phoneAuth',
      builder: (context, state) => const PhoneAuthScreen(),
    ),
    GoRoute(
      path: '/otp-verification',
      name: 'otpVerification',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return OtpVerificationScreen(
          phoneNumber: extras?['phoneNumber'] ?? '',
          verificationId: extras?['verificationId'] ?? '',
        );
      },
    ),
    GoRoute(
      path: '/account-type-selection',
      name: 'accountTypeSelection',
      builder: (context, state) => const AccountTypeSelectionScreen(),
    ),
    GoRoute(
      path: '/profile-setup',
      name: 'profileSetup',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>?;
        return ProfileSetupScreen(
          accountType: extras?['accountType'] ?? 'sender',
        );
      },
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
  ],
);
