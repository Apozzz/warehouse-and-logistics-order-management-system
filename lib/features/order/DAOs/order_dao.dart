import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/order/models/order_model.dart'
    as order;

class OrderDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<order.Order>> fetchOrders(String companyId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('companyId', isEqualTo: companyId)
          .get();

      return snapshot.docs.map((doc) {
        return order.Order.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  Future<void> addOrder(order.Order order) async {
    try {
      await _firestore.collection('orders').add(order.toMap());
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  Future<void> updateOrder(
      String orderId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection('orders').doc(orderId).update(updateData);
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  Future<int> getTotalOrders(String companyId) async {
    final QuerySnapshot snapshot = await _firestore
        .collection('orders')
        .where('companyId', isEqualTo: companyId)
        .get();

    return snapshot.docs.length;
  }
}
