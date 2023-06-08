import 'package:intl/intl.dart' as intl;

class Order {
  final int id;
  final String code;
  final String name;
  final String surname;
  final String phone;
  final String? serializedProductIds;
  final String? serializedProductQuantities;
  String createdAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Order(
    this.createdAt, {
    required this.id,
    required this.code,
    required this.name,
    required this.surname,
    required this.phone,
    required this.serializedProductIds,
    required this.serializedProductQuantities,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'surname': surname,
      'phone': phone,
      'serializedProductIds': serializedProductIds,
      'serializedProductQuantities': serializedProductQuantities,
      'createdAt': createdAt,
    };
  }

  Order createModel(Map<String, dynamic> data) {
    return Order(
      data['createdAt'].isEmpty ? createdAt : data['createdAt'],
      id: data['id'],
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      phone: data['phone'] ?? '',
      serializedProductIds: data['serializedProductIds'],
      serializedProductQuantities: data['serializedProductQuantities'],
    );
  }

  String getTableCheckQuery() {
    return 'SELECT COUNT(*) FROM ${getTableName()}';
  }

  String getTableName() {
    return 'orders';
  }

  String getHighestIdQuery() {
    return 'SELECT id FROM ${getTableName()} ORDER BY id DESC LIMIT 1';
  }

  String recreateTableQuery() {
    return 'DROP TABLE ${getTableName()}; ${getTableCreationString()};';
  }

  String getTableCreationString() {
    return 'CREATE TABLE ${getTableName()}(createdAt TEXT, id INTEGER PRIMARY KEY, code TEXT, name TEXT, surname TEXT, phone TEXT, serializedProductIds TEXT, serializedProductQuantities TEXT)';
  }

  @override
  String toString() {
    return 'Order{id: $id, code: $code, name: $name, surname: $surname, phone: $phone, serialized products: $serializedProductIds, serialized quantities: $serializedProductQuantities, created at: $createdAt}';
  }
}
