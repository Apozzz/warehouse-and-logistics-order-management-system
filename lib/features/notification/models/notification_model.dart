class NotificationModel {
  final int id;
  final String title;
  final String body;
  final String image; // Assuming you're using an image URL
  final String userId; // User to receive the notification
  final String companyId; // Company related to the notification
  final DateTime scheduledTime;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.image = '',
    required this.userId,
    required this.companyId,
    required this.scheduledTime,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> data, int id) {
    return NotificationModel(
      id: id,
      title: data['title'],
      body: data['body'],
      image: data['image'] ?? '',
      userId: data['userId'],
      companyId: data['companyId'],
      scheduledTime: DateTime.parse(data['scheduledTime']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'image': image,
      'userId': userId,
      'companyId': companyId,
      'scheduledTime': scheduledTime.toIso8601String(),
    };
  }

  NotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    String? image,
    String? userId,
    String? companyId,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      image: image ?? this.image,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      scheduledTime: createdAt ?? scheduledTime,
    );
  }

  bool get isEmpty =>
      id == 0 &&
      title.isEmpty &&
      body.isEmpty &&
      userId.isEmpty &&
      companyId.isEmpty;

  bool get isNotEmpty => !isEmpty;

  @override
  String toString() {
    return 'NotificationModel{id: $id, title: $title, body: $body, image: $image, userId: $userId, companyId: $companyId, scheduledTime: $scheduledTime}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NotificationModel &&
        other.id == id &&
        other.title == title &&
        other.body == body &&
        other.image == image &&
        other.userId == userId &&
        other.companyId == companyId &&
        other.scheduledTime == scheduledTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        body.hashCode ^
        image.hashCode ^
        userId.hashCode ^
        companyId.hashCode ^
        scheduledTime.hashCode;
  }

  static NotificationModel empty() {
    return NotificationModel(
      id: 0,
      title: '',
      body: '',
      image: '',
      userId: '',
      companyId: '',
      scheduledTime: DateTime.now(),
    );
  }
}
