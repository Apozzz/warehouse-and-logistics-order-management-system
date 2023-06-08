import 'package:intl/intl.dart' as intl;

enum DeliveryStatus {
  PREPARING,
  CANCELED,
  IN_PROGGRESS,
  DELIVERED,
}

class Delivery {
  final int id;
  final String code;
  final String name;
  final String surname;
  final String phone;
  final String courierIdentification;
  final int deliveryOrderId;
  final String deliveryDate;
  final String deliveryTo;
  final String deliveryFrom;
  final int deliveryStatus;
  String updatedAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  String createdAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Delivery(
    this.createdAt,
    this.updatedAt, {
    required this.id,
    required this.code,
    required this.name,
    required this.surname,
    required this.phone,
    required this.courierIdentification,
    required this.deliveryOrderId,
    required this.deliveryDate,
    required this.deliveryTo,
    required this.deliveryFrom,
    required this.deliveryStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'surname': surname,
      'phone': phone,
      'courierIdentification': courierIdentification,
      'deliveryOrderId': deliveryOrderId,
      'deliveryDate': deliveryDate,
      'deliveryTo': deliveryTo,
      'deliveryFrom': deliveryFrom,
      'deliveryStatus': deliveryStatus,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Delivery createModel(Map<String, dynamic> data) {
    return Delivery(
      data['createdAt'].isEmpty ? createdAt : data['createdAt'],
      data['updatedAt'].isEmpty ? updatedAt : data['updatedAt'],
      id: data['id'],
      code: data['code'] ?? '',
      name: data['name'] ?? '',
      surname: data['surname'] ?? '',
      phone: data['phone'] ?? '',
      courierIdentification: data['courierIdentification'] ?? '',
      deliveryOrderId: data['deliveryOrderId'],
      deliveryDate: data['deliveryDate'] ?? '',
      deliveryTo: data['deliveryTo'] ?? '',
      deliveryFrom: data['deliveryFrom'] ?? '',
      deliveryStatus: data['deliveryStatus'] ?? DeliveryStatus.PREPARING.index,
    );
  }

  String getTableCheckQuery() {
    return 'SELECT COUNT(*) FROM ${getTableName()}';
  }

  String getTableName() {
    return 'deliveries';
  }

  String getHighestIdQuery() {
    return 'SELECT id FROM ${getTableName()} ORDER BY id DESC LIMIT 1';
  }

  String recreateTableQuery() {
    return 'DROP TABLE ${getTableName()}; ${getTableCreationString()};';
  }

  String getTableCreationString() {
    return 'CREATE TABLE ${getTableName()}(createdAt TEXT, updatedAt TEXT, id INTEGER PRIMARY KEY, code TEXT, name TEXT, surname TEXT, phone TEXT, courierIdentification TEXT, deliveryOrderId INTEGER, deliveryDate TEXT, deliveryTo TEXT, deliveryFrom TEXT, deliveryStatus INTEGER)';
  }

  @override
  String toString() {
    return 'Delivery{id: $id, code: $code, name: $name, surname: $surname, phone: $phone, courierIdentification: $courierIdentification, order: $deliveryOrderId, delivery date: $deliveryDate, delivery to: $deliveryTo, delivery from: $deliveryFrom, delivery status: $deliveryStatus, created at: $createdAt, updated at: $updatedAt}';
  }
}
