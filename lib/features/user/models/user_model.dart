import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/enums/driving_category.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final List<String> companyIds;
  final Set<DrivingLicenseCategory> licensesHeld;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.companyIds,
    required this.licensesHeld,
  });

  // Factory constructor to create a User instance from a Map
  factory User.fromMap(Map<String, dynamic> data, String id) {
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    final licensesHeld = (data['licensesHeld'] as List<dynamic>?)
            ?.map((license) => DrivingLicenseCategory.values.firstWhere(
                (e) => e.toString().split('.').last == license,
                orElse: () => DrivingLicenseCategory.AM))
            .toSet() ??
        {};

    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      createdAt: createdAt,
      companyIds: List<String>.from(data['companyIds'] ?? []),
      licensesHeld: licensesHeld,
    );
  }

  // Method to convert a User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': createdAt,
      'companyIds': companyIds,
      'licensesHeld': licensesHeld
          .map((license) => license.toString().split('.').last)
          .toList(),
    };
  }

  static User empty() {
    return User(
      id: '',
      name: '',
      email: '',
      phoneNumber: '',
      createdAt: DateTime(0),
      companyIds: <String>[],
      licensesHeld: {},
    );
  }

  bool get isEmpty =>
      id.isEmpty &&
      name.isEmpty &&
      email.isEmpty &&
      phoneNumber.isEmpty &&
      companyIds.isEmpty &&
      licensesHeld.isEmpty;

  bool get isNotEmpty => !isEmpty;
}
