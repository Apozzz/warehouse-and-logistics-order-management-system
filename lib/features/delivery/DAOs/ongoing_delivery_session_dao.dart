import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/delivery/models/ongoing_delivery_session.dart';

class OngoingDeliverySessionDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<OngoingDeliverySession> createSession(
      OngoingDeliverySession session) async {
    final docRef =
        await _db.collection('ongoingDeliverySessions').add(session.toMap());
    return session.copyWith(
        id: docRef.id); // Return the session with the generated ID
  }

  Future<void> updateSession(
      String sessionId, Map<String, dynamic> updatedData) async {
    await _db
        .collection('ongoingDeliverySessions')
        .doc(sessionId)
        .update(updatedData);
  }

  Future<OngoingDeliverySession?> getSessionByUser(String userId) async {
    final result = await _db
        .collection('ongoingDeliverySessions')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      return OngoingDeliverySession.fromMap(
          result.docs.first.data(), result.docs.first.id);
    }
    return null;
  }

  Future<void> deleteSession(String sessionId) async {
    await _db.collection('ongoingDeliverySessions').doc(sessionId).delete();
  }
}
