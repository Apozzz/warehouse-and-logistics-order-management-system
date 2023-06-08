import 'package:intl/intl.dart' as intl;

class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String image;
  String createdAt =
      intl.DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  NotificationModel(
    this.createdAt, {
    required this.id,
    required this.title,
    required this.body,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'image': image,
      'createdAt': createdAt,
    };
  }

  NotificationModel createModel(Map<String, dynamic> data) {
    return NotificationModel(
      data['createdAt'].isEmpty ? createdAt : data['createdAt'],
      id: data['id'],
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      image: data['image'] ?? '',
    );
  }

  String getTableCheckQuery() {
    return 'SELECT COUNT(*) FROM ${getTableName()}';
  }

  String getTableName() {
    return 'notifications';
  }

  String getHighestIdQuery() {
    return 'SELECT id FROM ${getTableName()} ORDER BY id DESC LIMIT 1';
  }

  String recreateTableQuery() {
    return 'DROP TABLE ${getTableName()}; ${getTableCreationString()};';
  }

  String getTableCreationString() {
    return 'CREATE TABLE ${getTableName()}(createdAt TEXT, id INTEGER PRIMARY KEY, title TEXT, body TEXT, image TEXT)';
  }

  @override
  String toString() {
    return 'Notification{id: $id, title: $title, body: $body, image: $image, created at: $createdAt}';
  }
}
