import 'package:inventory_system/features/product/models/product_model.dart';

class OrderItem {
  final String productId;
  final int quantity;
  final double price;
  final String scanCode;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.scanCode,
  });

  factory OrderItem.empty() {
    return OrderItem(productId: '', quantity: 0, price: 0.0, scanCode: '');
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: map['price']?.toDouble() ??
          0.0, // Handle potential nulls and type conversion
      scanCode: map['scanCode'] ?? '',
    );
  }

  static OrderItem fromProduct(Product product, {int quantity = 1}) {
    return OrderItem(
      productId: product.id,
      quantity: quantity,
      price: product.price, // Use the product's price
      scanCode: product.scanCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price, // Include price in the map
      'scanCode': scanCode,
    };
  }
}
