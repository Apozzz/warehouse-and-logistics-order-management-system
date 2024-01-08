import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:inventory_system/utils/date_utils.dart';

class Warehouse {
  final String id;
  final String name;
  final String address;
  final DateTime createdAt;
  final String companyId;
  final Set<String> sectorIds;

  Warehouse({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
    required this.companyId,
    required this.sectorIds,
  });

  // Factory constructor to create a Warehouse instance from a Map
  factory Warehouse.fromMap(Map<String, dynamic> data, String id) {
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    var sectorsData = data['sectorIds'] as List<dynamic>? ?? [];
    Set<String> sectors = Set.from(sectorsData);

    return Warehouse(
      id: id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      createdAt: createdAt,
      companyId: data['companyId'] ?? '',
      sectorIds: sectors,
    );
  }

  // Method to convert a Warehouse instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'createdAt': CustomDateUtils.formatDate(createdAt),
      'companyId': companyId,
      'sectorIds': sectorIds.toList(),
    };
  }

  static Warehouse empty() {
    return Warehouse(
      id: '',
      name: '',
      createdAt: DateTime.now(),
      companyId: '',
      address: '',
      sectorIds: {},
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Warehouse &&
        other.id == id &&
        other.name == name &&
        other.address == address &&
        other.companyId == companyId &&
        setEquals(other.sectorIds, sectorIds);
  }

  @override
  int get hashCode => Object.hash(id, name, address, companyId, sectorIds);
}
