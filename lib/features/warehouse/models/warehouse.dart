import 'package:inventory_system/utils/date_utils.dart';

class Warehouse {
  final String id;
  final String name;
  final String address;
  final DateTime createdAt;
  final int companyId;

  Warehouse({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.companyId,
  });

  // Factory constructor to create a Warehouse instance from a Map
  factory Warehouse.fromMap(Map<String, dynamic> data, String id) {
    return Warehouse(
      id: id,
      name: data['name'],
      address: data['address'],
      createdAt: CustomDateUtils.parseDate(data['createdAt']),
      companyId: data['companyId'],
    );
  }

  // Method to convert a Warehouse instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'createdAt': CustomDateUtils.formatDate(createdAt),
      'companyId': companyId,
    };
  }
}
