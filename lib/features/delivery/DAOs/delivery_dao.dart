import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';

class DeliveryDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Creates a new delivery
  Future<Delivery> createDelivery(Delivery delivery) async {
    final docRef = await _db.collection('deliveries').add(delivery.toMap());
    return delivery.copyWith(
        id: docRef.id); // Update the delivery with the generated ID
  }

  // Fetches deliveries by their IDs
  Future<List<Delivery>> getDeliveriesByIds(List<String> deliveryIds) async {
    final deliveryDocs = await _db
        .collection('deliveries')
        .where(FieldPath.documentId, whereIn: deliveryIds)
        .get();
    return deliveryDocs.docs
        .map((doc) =>
            Delivery.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  // Fetches deliveries by companyId
  Future<List<Delivery>> fetchDeliveries(String companyId) async {
    final QuerySnapshot snapshot = await _db
        .collection('deliveries')
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) {
      return Delivery.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  // Updates a delivery
  Future<void> updateDelivery(
      String deliveryId, Map<String, dynamic> updatedData) async {
    await _db.collection('deliveries').doc(deliveryId).update(updatedData);
  }

  // Deletes a delivery by ID
  Future<void> deleteDelivery(String deliveryId) async {
    await _db.collection('deliveries').doc(deliveryId).delete();
  }

  Future<int> getTotalDeliveries(String companyId) async {
    final QuerySnapshot snapshot = await _db
        .collection('deliveries')
        .where('companyId', isEqualTo: companyId)
        .get();

    return snapshot.docs.length; // Returns the count of documents
  }
}
