import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { sender, carrier, both }

class UserModel {
  final String uid;
  final String phoneNumber;
  final String? fullName;
  final String? profileImageUrl;
  final String? idVerificationUrl;
  final String? idVerificationStatus; // 'pending', 'verified', 'rejected'
  final UserRole role;
  final double? rating;
  final int? totalRatings;
  final bool isVerified;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? fcmToken;

  UserModel({
    required this.uid,
    required this.phoneNumber,
    this.fullName,
    this.profileImageUrl,
    this.idVerificationUrl,
    this.idVerificationStatus,
    required this.role,
    this.rating,
    this.totalRatings,
    required this.isVerified,
    required this.createdAt,
    this.updatedAt,
    this.fcmToken,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'] as String,
      phoneNumber: data['phoneNumber'] as String,
      fullName: data['fullName'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      idVerificationUrl: data['idVerificationUrl'] as String?,
      idVerificationStatus: data['idVerificationStatus'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.sender,
      ),
      rating: (data['rating'] as num?)?.toDouble(),
      totalRatings: data['totalRatings'] as int?,
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      fcmToken: data['fcmToken'] as String?,
    );
  }

  factory UserModel.fromDocumentSnapshot(DocumentSnapshot doc) {
    return UserModel.fromMap(doc.data() as Map<String, dynamic>);
  }

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      phoneNumber: data['phoneNumber'] as String? ?? '',
      fullName: data['fullName'] as String?,
      profileImageUrl: data['profileImageUrl'] as String?,
      idVerificationUrl: data['idVerificationUrl'] as String?,
      idVerificationStatus: data['idVerificationStatus'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['role']}',
        orElse: () => UserRole.sender,
      ),
      rating: (data['rating'] as num?)?.toDouble(),
      totalRatings: data['totalRatings'] as int?,
      isVerified: data['isVerified'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
      fcmToken: data['fcmToken'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'profileImageUrl': profileImageUrl,
      'idVerificationUrl': idVerificationUrl,
      'idVerificationStatus': idVerificationStatus,
      'role': role.toString().split('.').last,
      'rating': rating,
      'totalRatings': totalRatings,
      'isVerified': isVerified,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'fcmToken': fcmToken,
    };
  }
}
