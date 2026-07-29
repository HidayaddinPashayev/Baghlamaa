import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  static String getUserFriendlyMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-phone-number':
          return 'Telefon nömrəsi keçərli deyil';
        case 'too-many-requests':
          return 'Çox sayda cəhd edildi. Zəhmət olmasa sonra yenidən cəhd edin';
        case 'invalid-verification-code':
          return 'SMS kodu yanlışdır';
        case 'session-expired':
          return 'Seansınız başa çatdı. Zəhmət olmasa yenidən cəhd edin';
        case 'user-disabled':
          return 'Bu hesab deaktivdir';
        case 'operation-not-allowed':
          return 'Bu əməliyyat icazə verilmir';
        default:
          return 'Giriş xətası: ${error.message}';
      }
    }
    return 'Gözlənilməz xəta baş verdi';
  }
}

class AppError implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AppError({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => message;
}
