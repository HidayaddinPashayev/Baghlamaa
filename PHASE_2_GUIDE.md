# Phase 2: Auth Flow Implementation - Complete Guide

## Overview
Phase 2 implements the complete user authentication and onboarding flow for Yolçanta. Users can now register with their phone number, verify via OTP, select their account type (sender or carrier), and complete their profile.

## Features Implemented

### 1. Phone Authentication
**File:** `lib/screens/auth/phone_auth_screen.dart`

- Phone number input with Azerbaijan format validation
- Real-time validation feedback
- Error handling for invalid numbers
- Integration with Firebase Authentication

**Usage Flow:**
```
User enters phone number (without +994 prefix) 
→ Validation checks format (10 digits, starts with 5 or 7)
→ Sends verification code to phone via SMS
→ Navigates to OTP verification screen
```

### 2. OTP Verification
**File:** `lib/screens/auth/otp_verification_screen.dart`

- 6-digit SMS code input
- Code validation
- Automatic navigation to account type selection on success
- Back button for retry

**Error Scenarios:**
- Invalid code (less/more than 6 digits)
- Expired code (2-minute timeout from verification sent)
- Firebase auth failures

### 3. Account Type Selection
**File:** `lib/screens/auth/account_type_selection_screen.dart`

- Visual cards for Sender and Carrier
- Easy switching between account types
- Icon-based differentiation

**Account Types:**
- **Sender (Göndərən):** Person sending parcels
- **Carrier (Kuryər):** Person transporting parcels

### 4. Profile Setup
**File:** `lib/screens/auth/profile_setup_screen.dart`

Form Fields:
- Profile picture (optional)
- Full name (required)
- Email (required, must be valid)
- Bio/Description (optional, max 500 chars)
- Account type-specific info

**Features:**
- Image picker from device gallery
- Form validation before submission
- Firebase Storage integration for profile images
- Automatic Firestore save with metadata

### 5. Home Screen
**File:** `lib/screens/home/home_screen.dart`

- Shows authenticated user info
- Logout functionality
- Placeholder for Phase 3+ features

## Architecture

### State Management (Riverpod)
```
authStateNotifierProvider
  ├── Manages current user state
  ├── Handles sign in/out
  └── Persists across app restarts

firestoreUserProvider
  └── One-time fetch of user data

firestoreUserStreamProvider
  └── Real-time user data updates

saveUserProfileProvider
  └── Saves/updates user profile to Firestore
```

### Services
```
AuthService
  ├── verifyPhoneNumber() - Sends OTP
  ├── signInWithOtp() - Verifies code & signs in
  ├── signOut() - Logs out user
  └── getCurrentUser() - Gets current Firebase user

ErrorHandler
  └── Converts Firebase exceptions to user-friendly Azerbaijani messages
```

### Utilities
```
Validators
  ├── isValidAzerbaijanPhone()
  ├── isValidEmail()
  ├── isValidFullName()
  └── isValidOTP()

Logger
  └── Debug logging with [Yolçanta] prefix

Constants
  ├── Collection names
  ├── Storage paths
  ├── App strings (Azerbaijani)
  └── Dimensions
```

## Data Flow

### Complete Auth Journey

```
SplashScreen (initializes)
    ↓
    └─→ Check Firebase auth state
        ├─→ User exists → Home Screen
        └─→ No user → Phone Auth

PhoneAuthScreen
    ↓
    ├─→ Validate phone
    └─→ Send OTP → OtpVerificationScreen

OtpVerificationScreen
    ↓
    ├─→ Validate code
    └─→ Sign in → AccountTypeSelectionScreen

AccountTypeSelectionScreen
    ↓
    ├─→ Select Sender → ProfileSetupScreen
    └─→ Select Carrier → ProfileSetupScreen

ProfileSetupScreen
    ↓
    ├─→ Pick image (optional) → Upload to Storage
    ├─→ Enter profile data
    └─→ Save to Firestore → HomeScreen
```

### Firestore User Document Structure

```json
{
  "uid": "firebase_user_id",
  "phoneNumber": "+994XXXXXXXXXX",
  "fullName": "User Name",
  "email": "user@example.com",
  "bio": "Short bio",
  "profileImageUrl": "https://storage-url...",
  "accountType": "sender|carrier",
  "isVerified": false,
  "rating": 0.0,
  "totalRatings": 0,
  "createdAt": "2024-01-01T10:00:00Z",
  "updatedAt": "2024-01-01T10:00:00Z",
  "fcmToken": "device_token"
}
```

## Routing

All routes managed in `lib/config/routes.dart`:

```
/splash                  → SplashScreen
/phone-auth             → PhoneAuthScreen
/otp-verification       → OtpVerificationScreen (with phone & verificationId)
/account-type-selection → AccountTypeSelectionScreen
/profile-setup          → ProfileSetupScreen (with accountType)
/home                   → HomeScreen
```

## Error Handling

All Firebase exceptions are mapped to user-friendly Azerbaijani messages:

```
invalid-phone-number    → "Telefon nömrəsi keçərli deyil"
too-many-requests       → "Çox sayda cəhd edildi. Zəhmət olmasa sonra yenidən cəhd edin"
invalid-verification-code → "SMS kodu yanlışdır"
session-expired         → "Seansınız başa çatdı"
user-disabled           → "Bu hesab deaktivdir"
```

## Configuration

### Firebase Setup Required
1. Create Firebase project in Firebase Console
2. Enable Phone Authentication
3. Create Firestore database with security rules
4. Enable Cloud Storage
5. Get credentials and update `lib/firebase_options.dart`

### Deployment
1. Deploy Firestore security rules:
   ```bash
   firebase deploy --only firestore:rules
   ```

2. Configure Firebase in Android (`android/app/google-services.json`)
3. Configure Firebase in iOS (`ios/Runner/GoogleService-Info.plist`)

## Validation Rules

### Phone Number
- Format: +994 followed by 10 digits
- Starts with 5 or 7 (mobile numbers in Azerbaijan)
- Example: +994 50 123 45 67

### Email
- Standard email format (RFC 5322)
- Must contain @ and domain

### Full Name
- Minimum 2 characters
- Maximum 100 characters
- Can contain spaces and special characters

### OTP Code
- Exactly 6 digits
- Numeric only
- Auto-filled after SMS receipt on compatible devices

## Testing Checklist

- [x] Phone number validation works
- [x] OTP code sent successfully
- [x] OTP verification with correct code
- [x] Error handling for wrong OTP
- [x] Account type selection
- [x] Profile image upload
- [x] Profile data saved to Firestore
- [x] Auth state persistence across app restarts
- [x] Splash screen routing works
- [x] Error messages in Azerbaijani

## Common Issues & Solutions

**Issue:** "Invalid phone number" error
- **Solution:** Ensure number format is correct. Remove any special characters except digits.

**Issue:** "Session expired" during verification
- **Solution:** Request new code. User has 2 minutes to enter code after SMS sent.

**Issue:** Profile image not uploading
- **Solution:** Check Firebase Storage permissions and ensure image file is readable.

**Issue:** User data not saving to Firestore
- **Solution:** Verify Firestore security rules are deployed and user is authenticated.

## Next Steps (Phase 3)

- Implement FCM token registration
- Create user profile view/edit screens
- Add profile image caching
- Implement carrier route posting
- Build sender search functionality

## Resources

- [Firebase Auth Documentation](https://firebase.flutter.dev/docs/auth/overview)
- [Firestore Documentation](https://firebase.flutter.dev/docs/firestore/overview)
- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
