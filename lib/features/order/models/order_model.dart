import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/enums/order_status.dart';
import 'package:inventory_system/features/order/models/oraderitem_model.dart';

class Order {
  final String id;
  final String companyId;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String customerName;
  final String customerAddress;
  final double total;
  final Set<String> categories; // New field to store unique categories
  final OrderStatus status;
  final String? declineReason;
  final String? imageUrl;

  Order({
    required this.id,
    required this.companyId,
    required this.createdAt,
    required this.items,
    required this.customerName,
    required this.customerAddress,
    required this.total,
    required this.categories,
    this.status = OrderStatus.Pending,
    this.declineReason,
    this.imageUrl,
  });

  factory Order.empty() {
    return Order(
      id: '',
      companyId: '',
      createdAt: DateTime.now(),
      items: [],
      customerName: '',
      customerAddress: '',
      total: 0,
      categories: {}, // Empty set for categories
      status: OrderStatus.Pending,
    );
  }

  factory Order.fromMap(Map<String, dynamic> data, String documentId) {
    final createdAt = data['createdAt'] is Timestamp
        ? (data['createdAt'] as Timestamp).toDate()
        : DateTime.now();

    List<OrderItem> items = [];
    if (data['items'] != null) {
      items = List.from(data['items'])
          .map((item) => OrderItem.fromMap(item as Map<String, dynamic>))
          .toList();
    }

    return Order(
      id: documentId,
      companyId: data['companyId'] ?? '',
      createdAt: createdAt,
      items: items,
      customerName: data['customerName'] ?? '',
      customerAddress: data['customerAddress'] ?? '',
      total: data['total'] ?? 0,
      categories: Set<String>.from(data['categories'] ?? []),
      status: OrderStatus.values[data['status'] ?? 0],
      declineReason: data['declineReason'],
      imageUrl: data['imageUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'createdAt': createdAt,
      'items': items.map((item) => item.toMap()).toList(),
      'customerName': customerName,
      'customerAddress': customerAddress,
      'total': total,
      'categories': categories.toList(), // Store the categories as a list
      'status': status.index,
      'declineReason': declineReason,
      'imageUrl': imageUrl,
    };
  }

  Order copyWith({
    String? id,
    String? companyId,
    DateTime? createdAt,
    List<OrderItem>? items,
    String? customerName,
    String? customerAddress,
    double? total,
    Set<String>? categories,
    OrderStatus? status,
    String? declineReason,
    String? imageUrl,
  }) {
    return Order(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
      customerName: customerName ?? this.customerName,
      customerAddress: customerAddress ?? this.customerAddress,
      total: total ?? this.total,
      categories: categories ?? this.categories,
      status: status ?? this.status,
      declineReason: declineReason ?? this.declineReason,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
