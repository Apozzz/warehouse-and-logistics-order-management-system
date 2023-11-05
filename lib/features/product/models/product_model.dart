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
  final List<String>? categories; // Optional: for categorizing products

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
    this.categories,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

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
      categories:
          (data['categories'] as List).map((item) => item as String).toList(),
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
      categories: null,
    );
  }
}
