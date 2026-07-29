import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import '../../providers/firestore_user_provider.dart';
import '../../models/user_model.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  final String accountType; // 'sender' or 'carrier'

  const ProfileSetupScreen({
    Key? key,
    required this.accountType,
  }) : super(key: key);

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _bioController = TextEditingController();
  File? _profileImage;
  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() => _profileImage = File(image.path));
      }
    } catch (e) {
      _showSnackBar('Şəkil seçməkdə xəta baş verdi');
    }
  }

  void _completeProfile() async {
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();
    final bio = _bioController.text.trim();

    if (fullName.isEmpty) {
      _showSnackBar('Zəhmət olmasa adınızı daxil edin');
      return;
    }

    if (email.isEmpty) {
      _showSnackBar('Zəhmət olmasa email daxil edin');
      return;
    }

    if (!email.contains('@')) {
      _showSnackBar('Keçərli email daxil edin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? profileImageUrl;

      // Upload profile image if selected
      if (_profileImage != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref();
          final userId = ref.read(authStateNotifierProvider).whenData(
                (user) => user?.uid ?? 'unknown',
              );
          
          final imageRef = storageRef.child('profile_images/$userId.jpg');
          await imageRef.putFile(_profileImage!);
          profileImageUrl = await imageRef.getDownloadURL();
        } catch (e) {
          _showSnackBar('Şəkil yüklənərkən xəta: ${e.toString()}');
        }
      }

      // Save user profile to Firestore
      final userData = {
        'fullName': fullName,
        'email': email,
        'bio': bio,
        'accountType': widget.accountType,
        'isVerified': false,
        'rating': 0.0,
        'totalRatings': 0,
      };

      if (profileImageUrl != null) {
        userData['profileImageUrl'] = profileImageUrl;
      }

      // Use ref to call the save provider
      await ref.read(saveUserProfileProvider(userData).future);

      if (mounted) {
        context.pushReplacementNamed('home');
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar('Profil yaradılarkən xəta baş verdi: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(message: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isSender = widget.accountType == 'sender';
    final screenTitle = isSender ? 'Profili Tamamla' : 'Kuryər Profili';

    return Scaffold(
      appBar: AppBar(
        title: Text(screenTitle),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile Picture Section
            Center(
              child: GestureDetector(
                onTap: _isLoading ? null : _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  backgroundImage: _profileImage != null
                      ? FileImage(_profileImage!)
                      : null,
                  child: _profileImage == null
                      ? Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Theme.of(context).primaryColor,
                        )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Şəkil Seçin',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 32),

            // Full Name Field
            TextField(
              controller: _fullNameController,
              enabled: !_isLoading,
              decoration: const InputDecoration(
                labelText: 'Ad Soyadı',
                hintText: 'Misal: Ahmet Məmmədov',
              ),
            ),
            const SizedBox(height: 16),

            // Email Field
            TextField(
              controller: _emailController,
              enabled: !_isLoading,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Misal: ahmet@example.com',
              ),
            ),
            const SizedBox(height: 16),

            // Bio Field
            TextField(
              controller: _bioController,
              enabled: !_isLoading,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Haqqında',
                hintText: 'Öz haqqınızda qısa məlumat verin',
              ),
            ),
            const SizedBox(height: 32),

            // Account Type Specific Info
            if (!isSender)
              Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kuryər Məlumatları',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Sonrakı adımda nəqliyyat məlumatlarını əlavə edəcəksiniz.',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _completeProfile,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Davam Et'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
