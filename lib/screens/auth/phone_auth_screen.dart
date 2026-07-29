import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/auth_provider.dart';

class PhoneAuthScreen extends ConsumerStatefulWidget {
  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends ConsumerState<PhoneAuthScreen> {
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _sendOtp() async {
    final phoneNumber = _phoneController.text.trim();

    // Validate phone number
    if (phoneNumber.isEmpty) {
      _showSnackBar(context, 'Zəhmət olmasa telefon nömrənizi daxil edin');
      return;
    }

    if (!RegExp(r'^\d{9,}$').hasMatch(phoneNumber)) {
      _showSnackBar(context, 'Keçərli telefon nömrəsi daxil edin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = ref.read(authServiceProvider);
      final fullPhoneNumber = '+994$phoneNumber';

      await authService.verifyPhoneNumber(
        fullPhoneNumber,
        (verificationId) {
          if (mounted) {
            context.pushNamed(
              'otpVerification',
              extra: {'phoneNumber': fullPhoneNumber, 'verificationId': verificationId},
            );
          }
        },
      );
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString();
        final userMessage = errorMessage.contains('too-many-requests')
            ? 'Çox sayda cəhd edildi. 5 dəqiqə sonra yenidən cəhd edin'
            : errorMessage.contains('invalid-phone-number')
                ? 'Telefon nömrəsi keçərli deyil'
                : errorMessage;
        _showSnackBar(userMessage);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
        },
      );
    } catch (e) {
      if (mounted) {
        _showSnackBar(context, 'Xəta: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(message: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yolçanta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Telefon Nömrənizi Daxil Edin',
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                hintText: '+994 50 XXX XX XX',
                prefixText: '+994 ',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendOtp,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Davam Et'),
            ),
          ],
        ),
      ),
    );
  }
}
