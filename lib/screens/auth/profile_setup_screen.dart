import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../providers/auth_provider.dart';
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
  File? _idVerificationImage;
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

  Future<void> _pickIdImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() => _idVerificationImage = File(image.path));
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

    // Validate ID verification for carriers
    if (widget.accountType != 'sender' && _idVerificationImage == null) {
      _showSnackBar('Zəhmət olmasa şəxsiyyət vəsiqənizin şəklini yükləyin');
      return;
    }

    setState(() => _isLoading = true);

    try {
      String? profileImageUrl;
      String? idVerificationUrl;
      final authState = ref.read(authStateNotifierProvider);
      final currentUser = authState.value;
      final userId = currentUser?.uid ?? 'unknown';

      // Upload profile image if selected
      if (_profileImage != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref();
          final imageRef = storageRef.child('profile_images/$userId.jpg');
          await imageRef.putFile(_profileImage!);
          profileImageUrl = await imageRef.getDownloadURL();
        } catch (e) {
          _showSnackBar('Profil şəkli yüklənərkən xəta: ${e.toString()}');
        }
      }

      // Upload ID verification image if carrier
      if (_idVerificationImage != null) {
        try {
          final storageRef = FirebaseStorage.instance.ref();
          final imageRef = storageRef.child('id_verification/$userId.jpg');
          await imageRef.putFile(_idVerificationImage!);
          idVerificationUrl = await imageRef.getDownloadURL();
        } catch (e) {
          _showSnackBar('Şəxsiyyət vəsiqə şəkli yüklənərkən xəta: ${e.toString()}');
        }
      }

      // Get phone number from auth
      final authState = ref.read(authStateNotifierProvider);
      final currentUser = authState.value;
      
      // Save user profile to Firestore
      final userData = {
        'fullName': fullName,
        'email': email,
        'bio': bio,
        'phoneNumber': currentUser?.phoneNumber ?? '',
        'role': widget.accountType == 'carrier' ? 'carrier' : 'sender',
        'isVerified': false,
        'rating': 0.0,
        'totalRatings': 0,
        'createdAt': FieldValue.serverTimestamp(),
      };

      if (profileImageUrl != null) {
        userData['profileImageUrl'] = profileImageUrl;
      }

      if (idVerificationUrl != null) {
        userData['idVerificationUrl'] = idVerificationUrl;
        userData['idVerificationStatus'] = 'pending';
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

            // ID Verification for Carriers
            if (widget.accountType != 'sender')
              Column(
                children: [
                  Text(
                    'Şəxsiyyət Vəsiqə Yoxlaması',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(
                            _idVerificationImage != null
                                ? Icons.check_circle
                                : Icons.document_scanner,
                            size: 48,
                            color: _idVerificationImage != null
                                ? Colors.green
                                : Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _idVerificationImage != null
                                ? 'Şəkil seçildi ✓'
                                : 'Şəxsiyyət vəsiqənizin şəklini seçin',
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _isLoading ? null : _pickIdImage,
                            icon: const Icon(Icons.image),
                            label: const Text('Şəkil Seçin'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Şəxsiyyət vəsiqənizin aydın şəklini yükləyin. Bu məlumat yalnız doğrulama üçün istifadə olunacaq.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                    textAlign: TextAlign.center,
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
