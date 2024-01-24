import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final String scanCode; // Renamed from barcode
  final double price;
  final String? warehouseId;
  final int quantity;
  final DateTime createdAt;
  final String companyId;
  final Set<String> categories; // Optional: for categorizing products
  final String? sectorId;

  // final double height;
  // final double length;
  // final double width;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.scanCode,
    required this.price,
    this.warehouseId,
    required this.quantity,
    required this.createdAt,
    required this.companyId,
    required this.categories,
    this.sectorId,
    // required this.height,
    // required this.length,
    // required this.width,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    Set<String>? categories;
    if (data['categories'] != null) {
      categories = Set<String>.from(data['categories']);
    }

    return Product(
      id: documentId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      scanCode: data['scanCode'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      warehouseId: data['warehouseId'],
      quantity: data['quantity'] ?? 0,
      createdAt: createdAt,
      companyId: data['companyId'] ?? '',
      categories: categories ?? {},
      sectorId: data['sectorId'],
      // height: data['height']?.toDouble() ?? 0.0,
      // length: data['length']?.toDouble() ?? 0.0,
      // width: data['width']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'scanCode': scanCode,
      'price': price,
      'warehouseId': warehouseId,
      'quantity': quantity,
      'createdAt': createdAt,
      'companyId': companyId,
      'categories': categories,
      'sectorId': sectorId,
    };
  }

  static Product empty() {
    return Product(
      id: '',
      name: '',
      description: '',
      scanCode: '',
      price: 0.0,
      warehouseId: null,
      quantity: 0,
      createdAt: DateTime.now(),
      companyId: '',
      categories: {},
      sectorId: null,
    );
  }
}
