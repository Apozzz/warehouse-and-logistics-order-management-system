import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final DateTime createdAt;
  final List<String> companyIds;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.createdAt,
    required this.companyIds,
  });

  // Factory constructor to create a User instance from a Map
  factory User.fromMap(Map<String, dynamic> data, String id) {
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    return User(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      createdAt: createdAt,
      companyIds: List<String>.from(data['companyIds'] ?? []),
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
    );
  }

  bool get isEmpty =>
      id.isEmpty &&
      name.isEmpty &&
      email.isEmpty &&
      phoneNumber.isEmpty &&
      companyIds.isEmpty;
  bool get isNotEmpty => !isEmpty;
}
