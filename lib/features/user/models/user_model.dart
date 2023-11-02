import 'package:inventory_system/utils/date_utils.dart';

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
    return User(
      id: id,
      name: data['name'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      createdAt: CustomDateUtils.parseDate(data['createdAt']),
      companyIds: data['companyIds'],
    );
  }

  // Method to convert a User instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'createdAt': CustomDateUtils.formatDate(createdAt),
      'companyIds': companyIds,
    };
  }
}
