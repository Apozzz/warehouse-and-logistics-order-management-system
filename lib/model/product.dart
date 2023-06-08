import 'package:intl/intl.dart' as intl;

class Product {
  final int id;
  final String name;
  final String description;
  final String barcode;
  final String qrcode;
  final double price;
  final int? warehouseId;
  final int quantity;
  String createdAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Product(
    this.createdAt, {
    required this.id,
    required this.name,
    required this.description,
    this.barcode = '',
    this.qrcode = '',
    this.price = 0.0,
    this.warehouseId,
    this.quantity = 0,
  });

  Product createModel(Map<String, dynamic> data) {
    return Product(
      data['createdAt'].isEmpty ? createdAt : data['createdAt'],
      id: data['id'],
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      barcode: data['barcode'] ?? '',
      qrcode: data['qrcode'] ?? '',
      price: data['price'] ?? 0.0,
      warehouseId: data['warehouseId'],
      quantity: data['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'barcode': barcode,
      'qrcode': qrcode,
      'price': price,
      'warehouseId': warehouseId,
      'quantity': quantity,
      'createdAt': createdAt,
    };
  }

  String getTableCheckQuery() {
    return 'SELECT COUNT(*) FROM ${getTableName()}';
  }

  String getTableName() {
    return 'products';
  }

  String getHighestIdQuery() {
    return 'SELECT id FROM ${getTableName()} ORDER BY id DESC LIMIT 1';
  }

  String recreateTableQuery() {
    return 'DROP TABLE ${getTableName()}; ${getTableCreationString()};';
  }

  String getTableCreationString() {
    return 'CREATE TABLE ${getTableName()}(createdAt TEXT, id INTEGER PRIMARY KEY, name TEXT, description TEXT, qrcode TEXT, barcode TEXT, price REAL, warehouseId INTEGER, quantity INTEGER)';
  }

  String getProductByScanQuery(String scan, String column) {
    return "SELECT * FROM ${getTableName()} WHERE $column = '$scan' LIMIT 1";
  }

  @override
  String toString() {
    return 'Product{id: $id, name: $name, description: $description, barcode: $barcode, qrcode: $qrcode, price: $price, warehouseId: $warehouseId, created at: $createdAt, quantity: $quantity}';
  }
}
