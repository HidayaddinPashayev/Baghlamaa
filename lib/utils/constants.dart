class AppConstants {
  // Timeouts
  static const int phoneVerificationTimeout = 120; // seconds
  static const int otpResendTimeout = 30; // seconds
  static const int requestTimeout = 30; // seconds

  // Validation
  static const int minPhoneLength = 10;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int maxBioLength = 500;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String routesCollection = 'routes';
  static const String bookingsCollection = 'bookings';
  static const String chatsCollection = 'chats';
  static const String ratingsCollection = 'ratings';
  static const String disputesCollection = 'disputes';
  static const String routeAlertsCollection = 'route_alerts';

  // Storage Paths
  static const String profileImagesPath = 'profile_images';
  static const String deliveryPhotosPath = 'delivery_photos';
  static const String chatImagesPath = 'chat_images';

  // User Roles
  static const String senderRole = 'sender';
  static const String carrierRole = 'carrier';

  // Booking Status
  static const String bookingPending = 'pending';
  static const String bookingAccepted = 'accepted';
  static const String bookingRejected = 'rejected';
  static const String bookingCompleted = 'completed';
  static const String bookingCancelled = 'cancelled';

  // Route Status
  static const String routeActive = 'active';
  static const String routeCompleted = 'completed';
  static const String routeCancelled = 'cancelled';

  // Error Codes
  static const String errorPhoneVerification = 'PHONE_VERIFICATION_ERROR';
  static const String errorOTPInvalid = 'OTP_INVALID';
  static const String errorUserNotFound = 'USER_NOT_FOUND';
  static const String errorUnauthorized = 'UNAUTHORIZED';
}

class AppStrings {
  // Common
  static const String appName = 'Yolçanta';
  static const String continueText = 'Davam Et';
  static const String backText = 'Geri';
  static const String cancelText = 'Ləğv Et';
  static const String saveText = 'Yadda Saxla';
  static const String deleteText = 'Sil';
  static const String editText = 'Redaktə Et';
  static const String loadingText = 'Yüklənir...';

  // Auth Screens
  static const String phoneNumberLabel = 'Telefon Nömrəsi';
  static const String phoneNumberHint = '+994 50 XXX XX XX';
  static const String enterPhoneNumber = 'Telefon Nömrənizi Daxil Edin';
  static const String enterOTPCode = 'SMS Kodunu Daxil Edin';
  static const String selectAccountType = 'Siz Kim Siniz?';
  static const String sender = 'Göndərən';
  static const String carrier = 'Kuryər';

  // Errors
  static const String errorOccurred = 'Xəta baş verdi';
  static const String tryAgain = 'Yenidən cəhd edin';
  static const String noInternet = 'İnternet bağlantısı yoxdur';
  static const String sessionExpired = 'Seansınız başa çatdı. Zəhmət olmasa giriş edin';
}

class AppDimensions {
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  static const double borderRadiusSmall = 4.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 16.0;

  static const double iconSizeSmall = 16.0;
  static const double iconSizeMedium = 24.0;
  static const double iconSizeLarge = 32.0;
}
