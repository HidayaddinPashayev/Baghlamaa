import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import 'firebase_provider.dart';

// Get current user document from Firestore
final firestoreUserProvider = FutureProvider<UserModel?>((ref) async {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  
  final currentUser = auth.currentUser;
  if (currentUser == null) return null;

  try {
    final doc = await firestore.collection('users').doc(currentUser.uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc.data() ?? {}, doc.id);
    }
    return null;
  } catch (e) {
    rethrow;
  }
});

// Stream of current user for real-time updates
final firestoreUserStreamProvider = StreamProvider<UserModel?>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  
  final currentUser = auth.currentUser;
  if (currentUser == null) {
    return Stream.value(null);
  }

  return firestore
      .collection('users')
      .doc(currentUser.uid)
      .snapshots()
      .map((doc) {
        if (doc.exists) {
          return UserModel.fromFirestore(doc.data() ?? {}, doc.id);
        }
        return null;
      });
});

// Save/update user profile
final saveUserProfileProvider = FutureProvider.family<void, Map<String, dynamic>>((ref, userData) async {
  final auth = ref.watch(firebaseAuthProvider);
  final firestore = ref.watch(firestoreProvider);
  
  final currentUser = auth.currentUser;
  if (currentUser == null) {
    throw Exception('No authenticated user');
  }

  try {
    await firestore.collection('users').doc(currentUser.uid).set(
      {
        ...userData,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );
  } catch (e) {
    rethrow;
  }
});
