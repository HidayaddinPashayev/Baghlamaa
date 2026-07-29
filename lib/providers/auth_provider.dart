import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';
import 'firebase_provider.dart';

// Auth Service Provider
final authServiceProvider = Provider<AuthService>((ref) {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  return AuthService(firebaseAuth);
});

// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AsyncValue<User?>> {
  final AuthService _authService;

  AuthStateNotifier(this._authService) : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final user = _authService.firebaseAuth.currentUser;
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> verifyPhoneNumber(
    String phoneNumber,
    Function(String) onCodeSent,
  ) async {
    try {
      await _authService.verifyPhoneNumber(phoneNumber, onCodeSent);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signInWithOtp(String verificationId, String smsCode) async {
    try {
      state = const AsyncValue.loading();
      await _authService.signInWithOtp(verificationId, smsCode);
      final user = _authService.firebaseAuth.currentUser;
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signOut() async {
    try {
      state = const AsyncValue.loading();
      await _authService.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authStateNotifierProvider =
    StateNotifierProvider<AuthStateNotifier, AsyncValue<User?>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthStateNotifier(authService);
});
