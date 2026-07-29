import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Firebase Auth Provider
final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

// Firestore Provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

// Firebase Storage Provider
final firebaseStorageProvider = Provider<FirebaseStorage>((ref) {
  return FirebaseStorage.instance;
});

// Firebase Messaging Provider
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

// Auth State Provider - tracks current user
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(firebaseAuthProvider).authStateChanges();
});

// Current User Provider
final currentUserProvider = FutureProvider<User?>((ref) async {
  return ref.watch(firebaseAuthProvider).currentUser;
});
