import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/notification/models/notification_model.dart';

class NotificationDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Adds a new notification to Firestore
  Future<NotificationModel> createNotification(
      NotificationModel notification) async {
    final docRef =
        await _db.collection('notifications').add(notification.toMap());
    return notification.copyWith(
        id: docRef.id.hashCode); // Hash the document ID to get an integer ID
  }

  // Fetches notifications for a specific user
  Future<List<NotificationModel>> getUserCompanyNotifications(
      String userId, String companyId) async {
    final querySnapshot = await _db
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('companyId', isEqualTo: companyId)
        .orderBy('scheduledTime', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => NotificationModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id.hashCode))
        .toList();
  }

  // Fetches notifications for a specific company
  Future<List<NotificationModel>> getCompanyNotifications(
      String companyId) async {
    final querySnapshot = await _db
        .collection('notifications')
        .where('companyId', isEqualTo: companyId)
        .orderBy('scheduledTime', descending: true)
        .get();

    return querySnapshot.docs
        .map((doc) => NotificationModel.fromMap(
            doc.data() as Map<String, dynamic>, doc.id.hashCode))
        .toList();
  }

  // Updates a notification
  Future<void> updateNotification(
      int notificationId, Map<String, dynamic> updatedData) async {
    final docRef = _db.collection('notifications').doc(notificationId
        .toString()); // Convert the ID back to string format for Firestore
    await docRef.update(updatedData);
  }

  // Deletes a notification
  Future<void> deleteNotification(int notificationId) async {
    final docRef =
        _db.collection('notifications').doc(notificationId.toString());
    await docRef.delete();
  }

  // Fetches the total number of notifications for a company
  Future<int> getTotalNotifications(String companyId) async {
    final querySnapshot = await _db
        .collection('notifications')
        .where('companyId', isEqualTo: companyId)
        .get();

    return querySnapshot.docs.length;
  }
}
