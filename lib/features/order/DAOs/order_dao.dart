import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/order/models/order_model.dart'
    as order;
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/product/models/product_model.dart';

class OrderDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ProductDAO _productDAO;

  OrderDAO(this._productDAO);

  Future<List<order.Order>> fetchOrders(String companyId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('orders')
          .where('companyId', isEqualTo: companyId)
          .orderBy('status')
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

  Future<List<Product>> getProductsInOrder(String orderId) async {
    // Assume each order has a list of productIds
    final orderSnapshot =
        await _firestore.collection('orders').doc(orderId).get();
    if (!orderSnapshot.exists) {
      throw Exception('Order not found');
    }
    List<String> productIds =
        List<String>.from(orderSnapshot.data()?['productIds'] ?? []);
    return Future.wait(productIds.map((id) => _productDAO.getProductById(id)));
  }

  Future<order.Order?> getOrderById(String orderId) async {
    try {
      final DocumentSnapshot docSnapshot =
          await _firestore.collection('orders').doc(orderId).get();

      if (docSnapshot.exists) {
        return order.Order.fromMap(
            docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
      } else {
        // Handle the case where the order does not exist
        print("Order not found");
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print("Error fetching order: $e");
      return null;
    }
  }

  Future<List<order.Order>> fetchOrdersByIds(List<String> orderIds) async {
    try {
      if (orderIds.isEmpty) {
        return [];
      }

      final orderDocs = await _firestore
          .collection('orders')
          .where(FieldPath.documentId, whereIn: orderIds)
          .get();

      return orderDocs.docs
          .map((doc) => order.Order.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      // Handle exceptions
      print("Error fetching orders: $e");
      return [];
    }
  }
}
