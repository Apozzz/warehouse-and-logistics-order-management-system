import 'package:cloud_firestore/cloud_firestore.dart';

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
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    return Company(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      createdAt: createdAt,
      ceo: data['ceo'] ?? '',
      userRoles: Map<String, String>.from(data['userRoles'] ?? {}),
    );
  }

  // Method to convert a Company instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'createdAt': createdAt,
      'ceo': ceo,
      'userRoles': userRoles,
    };
  }

  Company copyWith({
    String? id,
    String? name,
    String? address,
    DateTime? createdAt,
    String? ceo,
    Map<String, String>? userRoles,
  }) {
    return Company(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      ceo: ceo ?? this.ceo,
      userRoles: userRoles ?? this.userRoles,
    );
  }
}
