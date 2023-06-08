import 'package:intl/intl.dart' as intl;

class Authentication {
  final int id;
  final int status;
  final String code;
  String createdAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  Authentication(
    this.createdAt, {
    required this.id,
    required this.status,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'status': status,
      'code': code,
      'createdAt': createdAt,
    };
  }

  Authentication createModel(Map<String, dynamic> data) {
    return Authentication(
      data['createdAt'].isEmpty ? createdAt : data['createdAt'],
      id: data['id'],
      status: data['status'] ?? 0,
      code: data['code'] ?? '',
    );
  }

  String getTableCheckQuery() {
    return 'SELECT COUNT(*) FROM ${getTableName()}';
  }

  String getTableName() {
    return 'authentications';
  }

  String getHighestIdQuery() {
    return 'SELECT id FROM ${getTableName()} ORDER BY id DESC LIMIT 1';
  }

  String recreateTableQuery() {
    return 'DROP TABLE ${getTableName()}; ${getTableCreationString()};';
  }

  String getTableCreationString() {
    return 'CREATE TABLE ${getTableName()}(createdAt TEXT, id INTEGER PRIMARY KEY, status INTEGER, code TEXT)';
  }

  @override
  String toString() {
    return 'Authentication{id: $id, status: $status, code: $code, created at: $createdAt}';
  }
}
