import 'package:intl/intl.dart' as intl;

class Warehouse {
  final int id;
  final String code;
  final String name;
  final String address;
  String createdAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Warehouse(
    this.createdAt, {
    required this.id,
    required this.code,
    required this.name,
    required this.address,
  });

  Warehouse createModel(Map<String, dynamic> data) {
    return Warehouse(
      data['createdAt'].isEmpty ? createdAt : data['createdAt'],
      id: data['id'],
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      address: data['address'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'address': address,
      'createdAt': createdAt,
    };
  }

  String getName() {
    return name;
  }

  String getTableCheckQuery() {
    return 'SELECT COUNT(*) FROM ${getTableName()}';
  }

  String getTableName() {
    return 'warehouses';
  }

  String getHighestIdQuery() {
    return 'SELECT id FROM ${getTableName()} ORDER BY id DESC LIMIT 1';
  }

  String recreateTableQuery() {
    return 'DROP TABLE ${getTableName()}; ${getTableCreationString()};';
  }

  String getTableCreationString() {
    return 'CREATE TABLE ${getTableName()}(createdAt TEXT, id INTEGER PRIMARY KEY, code TEXT, name TEXT, address TEXT)';
  }

  @override
  String toString() {
    return 'Warehouse{id: $id, code: $code, name: $name, address: $address, created at: $createdAt}';
  }
}
