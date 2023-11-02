import 'package:inventory_system/utils/date_utils.dart';

class Company {
  final String id;
  final String name;
  final String address;
  final DateTime createdAt;
  final String ceo;
  final Map<String, String> userRoles;

  Company({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.ceo,
    required this.userRoles,
  });

  // Factory constructor to create a Company instance from a Map
  factory Company.fromMap(Map<String, dynamic> data, String id) {
    return Company(
      id: id,
      name: data['name'],
      address: data['address'],
      createdAt: CustomDateUtils.parseDate(data['createdAt']),
      ceo: data['ceo'],
      userRoles: data['userRoles'],
    );
  }

  // Method to convert a Company instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'createdAt': CustomDateUtils.formatDate(createdAt),
      'ceo': ceo,
      'userRoles': userRoles,
    };
  }
}
