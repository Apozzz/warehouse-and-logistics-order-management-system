import 'package:flutter/foundation.dart';

enum DeliveryStatus {
  Preparing,
  InTransit,
  Delivered,
  Cancelled,
}

class Delivery {
  final String id;
  final DateTime deliveryDate;
  final List<String> orderIds;
  final String vehicleId;
  final DeliveryStatus status;
  final String companyId;

  Delivery({
    required this.id,
    required this.deliveryDate,
    required this.orderIds,
    required this.vehicleId,
    required this.status,
    required this.companyId,
  });

  // Factory constructor to create a Delivery instance from a Map
  factory Delivery.fromMap(Map<String, dynamic> data, String id) {
    return Delivery(
      id: id,
      deliveryDate: DateTime.parse(data['deliveryDate']),
      orderIds: List<String>.from(data['orderIds']),
      vehicleId: data['vehicleId'],
      status: DeliveryStatus.values[data['status']],
      companyId: data['companyId'],
    );
  }

  // Method to convert a Delivery instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'deliveryDate': deliveryDate.toIso8601String(),
      'orderIds': orderIds,
      'vehicleId': vehicleId,
      'status': status.index,
      'companyId': companyId,
    };
  }

  // Creates a copy of the Delivery instance with altered fields
  Delivery copyWith({
    String? id,
    DateTime? deliveryDate,
    List<String>? orderIds,
    String? vehicleId,
    DeliveryStatus? status,
    String? companyId,
  }) {
    return Delivery(
      id: id ?? this.id,
      deliveryDate: deliveryDate ?? this.deliveryDate,
      orderIds: orderIds ?? this.orderIds,
      vehicleId: vehicleId ?? this.vehicleId,
      status: status ?? this.status,
      companyId: companyId ?? this.companyId,
    );
  }

  // Check if Delivery is empty
  bool get isEmpty => id.isEmpty && orderIds.isEmpty && vehicleId.isEmpty;

  // Check if Delivery is not empty
  bool get isNotEmpty => !isEmpty;

  // Overriding toString for better readability during debugging
  @override
  String toString() {
    return 'Delivery{id: $id, deliveryDate: $deliveryDate, orderIds: $orderIds, vehicleId: $vehicleId, status: $status}';
  }

  // Overriding equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Delivery &&
        other.id == id &&
        other.deliveryDate == deliveryDate &&
        listEquals(other.orderIds, orderIds) &&
        other.vehicleId == vehicleId &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        deliveryDate.hashCode ^
        orderIds.hashCode ^
        vehicleId.hashCode ^
        status.hashCode;
  }

  // Static method to create an empty Delivery instance
  static Delivery empty() {
    return Delivery(
      id: '',
      deliveryDate: DateTime.now(),
      orderIds: [],
      vehicleId: '',
      status: DeliveryStatus.Preparing,
      companyId: '',
    );
  }
}
