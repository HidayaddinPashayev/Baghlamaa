# Yolçanta - Peer-to-Peer Parcel Delivery Marketplace

A Flutter mobile application connecting parcel senders in Baku with carriers traveling to rural Azerbaijan cities.

## Getting Started

### Prerequisites
- Flutter 3.13.0 or later
- Firebase project with enabled services:
  - Authentication (Phone OTP)
  - Cloud Firestore
  - Storage
  - Cloud Messaging
  - Cloud Functions

### Setup Instructions

1. **Firebase Configuration**
   - Create a Firebase project at https://console.firebase.google.com
   - Replace placeholder values in `lib/firebase_options.dart` with your project credentials

2. **Deploy Firestore Security Rules**
   ```bash
   firebase deploy --only firestore:rules
   ```

3. **Install Dependencies**
   ```bash
   flutter pub get
   ```

4. **Generate Riverpod Code** (if using Riverpod generator)
   ```bash
   flutter pub run build_runner build
   ```

5. **Run the App**
   ```bash
   flutter run
   ```

## Project Structure

- `lib/` - Source code
- `lib/models/` - Data models
- `lib/providers/` - Riverpod state management
- `lib/services/` - Business logic services
- `lib/screens/` - UI screens
- `lib/config/` - App configuration (routes, theme)
- `firestore.rules` - Security rules for Firestore

## Architecture

- **State Management**: Riverpod
- **Navigation**: GoRouter
- **Database**: Cloud Firestore
- **Authentication**: Firebase Phone OTP
- **Storage**: Firebase Storage
- **Push Notifications**: Firebase Cloud Messaging

## Localization

UI text is in Azerbaijani. String resources are managed in `assets/locales/`.

## Implementation Phases

See `IMPLEMENTATION_LOG.md` for detailed progress tracking.

1. Phase 1: Firebase Setup & Flutter Scaffold ✅
2. Phase 2: Auth Flow Implementation
3. Phase 3: Carrier Route Management
4. Phase 4: Sender Search & Filtering
5. Phase 5: Booking & Carrier Response
6. Phase 6: Chat & Pickup Coordination
7. Phase 7: Delivery Handoff & Rating
8. Phase 8: Dispute Resolution
9. Phase 9: Admin Web Dashboard & Polish
