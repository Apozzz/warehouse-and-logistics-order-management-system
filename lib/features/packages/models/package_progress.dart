// package_progress.dart
import 'package:inventory_system/enums/package_progress_status.dart';

class PackageProgress {
  final String id;
  final String companyId;
  final String deliveryId;
  final String orderId;
  final String productId;
  final String userId;
  final String scanCode;
  final int quantity;
  final int packagedQuantity;
  final PackageProgressStatus status;
  final String? declineReason;

  PackageProgress({
    required this.id,
    required this.companyId,
    required this.deliveryId,
    required this.orderId,
    required this.productId,
    required this.userId,
    required this.scanCode,
    required this.quantity,
    this.packagedQuantity = 0,
    this.status = PackageProgressStatus.NotStarted,
    this.declineReason,
  });

  // Factory constructor to create a PackageProgress instance from a Map
  factory PackageProgress.fromMap(Map<String, dynamic> data, String id) {
    return PackageProgress(
      id: id,
      companyId: data['companyId'],
      deliveryId: data['deliveryId'],
      orderId: data['orderId'],
      productId: data['productId'],
      userId: data['userId'],
      scanCode: data['scanCode'],
      quantity: data['quantity'],
      packagedQuantity: data['packagedQuantity'],
      status: PackageProgressStatus.values[data['status']],
      declineReason: data['declineReason'],
    );
  }

  // Method to convert a PackageProgress instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'companyId': companyId,
      'deliveryId': deliveryId,
      'orderId': orderId,
      'productId': productId,
      'userId': userId,
      'scanCode': scanCode,
      'quantity': quantity,
      'packagedQuantity': packagedQuantity,
      'status': status.index,
      'declineReason': declineReason,
    };
  }

  // Creates a copy of the PackageProgress instance with altered fields
  PackageProgress copyWith({
    String? id,
    String? companyId,
    String? deliveryId,
    String? orderId,
    String? productId,
    String? userId,
    String? scanCode,
    int? quantity,
    int? packagedQuantity,
    PackageProgressStatus? status,
    String? declineReason,
  }) {
    return PackageProgress(
      id: id ?? this.id,
      companyId: companyId ?? this.companyId,
      deliveryId: deliveryId ?? this.deliveryId,
      orderId: orderId ?? this.orderId,
      productId: productId ?? this.productId,
      userId: userId ?? this.userId,
      scanCode: scanCode ?? this.scanCode,
      quantity: quantity ?? this.quantity,
      packagedQuantity: packagedQuantity ?? this.packagedQuantity,
      status: status ?? this.status,
      declineReason: declineReason ?? this.declineReason,
    );
  }

  // Overriding toString for better readability during debugging
  @override
  String toString() {
    return 'PackageProgress{id: $id, companyId: $companyId, deliveryId: $deliveryId, orderId: $orderId, productId: $productId, userId: $userId, scanCode: $scanCode, quantity: $quantity, packagedQuantity: $packagedQuantity, status: $status}';
  }

  // Overriding equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PackageProgress &&
        other.id == id &&
        other.companyId == companyId &&
        other.deliveryId == deliveryId &&
        other.orderId == orderId &&
        other.productId == productId &&
        other.userId == userId &&
        other.scanCode == scanCode &&
        other.quantity == quantity &&
        other.packagedQuantity == packagedQuantity &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companyId.hashCode ^
        deliveryId.hashCode ^
        orderId.hashCode ^
        productId.hashCode ^
        userId.hashCode ^
        scanCode.hashCode ^
        quantity.hashCode ^
        packagedQuantity.hashCode ^
        status.hashCode;
  }
}
