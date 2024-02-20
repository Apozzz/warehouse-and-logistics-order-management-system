import 'package:inventory_system/features/delivery/DAOs/ongoing_delivery_session_dao.dart';
import 'package:inventory_system/features/delivery/models/ongoing_delivery_session.dart';

class OngoingDeliverySessionService {
  final OngoingDeliverySessionDAO sessionDAO;

  OngoingDeliverySessionService(this.sessionDAO);

  Future<OngoingDeliverySession> startSession(
      String deliveryId, String userId, String companyId) async {
    OngoingDeliverySession session = OngoingDeliverySession(
      id: '', // Initially empty
      deliveryId: deliveryId,
      userId: userId,
      companyId: companyId,
      locations: [],
      startTime: DateTime.now(),
    );

    // Create the session in Firestore and get it back with the ID
    session = await sessionDAO.createSession(session);
    return session; // Return the session with the Firestore-generated ID
  }

  Future<void> updateSession(
      String sessionId, Map<String, dynamic> updatedData) async {
    await sessionDAO.updateSession(sessionId, updatedData);
  }

  Future<OngoingDeliverySession?> getSessionByUser(String userId) async {
    return sessionDAO.getSessionByUser(userId);
  }

  Future<void> endSession(String sessionId) async {
    await sessionDAO.deleteSession(sessionId);
  }

  Future<bool> checkForExistingSession(String userId) async {
    final existingSession = await getSessionByUser(userId);
    return existingSession != null;
  }
}
