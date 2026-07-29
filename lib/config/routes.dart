import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/auth/phone_auth_screen.dart';
import '../screens/auth/otp_verification_screen.dart';

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
        final phoneNumber = state.extra as String?;
        return OtpVerificationScreen(phoneNumber: phoneNumber ?? '');
      },
    ),
  ],
);
