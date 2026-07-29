import 'package:firebase_auth/firebase_auth.dart';
import 'error_handler.dart';

class AuthService {
  final FirebaseAuth firebaseAuth;
  String? _verificationId;

  AuthService(this.firebaseAuth);

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String) onCodeSent,
  ) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          try {
            await firebaseAuth.signInWithCredential(credential);
          } catch (e) {
            throw AppError(
              message: 'Avtomatik doğrulama xətası',
              originalError: e,
            );
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          throw AppError(
            message: AuthErrorHandler.getUserFriendlyMessage(e),
            code: e.code,
            originalError: e,
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
        timeout: const Duration(minutes: 2),
      );
    } on FirebaseAuthException catch (e) {
      throw AppError(
        message: AuthErrorHandler.getUserFriendlyMessage(e),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithOtp(
    String verificationId,
    String smsCode,
  ) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw AppError(
        message: AuthErrorHandler.getUserFriendlyMessage(e),
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      throw AppError(
        message: 'Giriş xətası: ${e.toString()}',
        originalError: e,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw AppError(
        message: 'Çıxış xətası: ${e.toString()}',
        originalError: e,
      );
    }
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }
}
