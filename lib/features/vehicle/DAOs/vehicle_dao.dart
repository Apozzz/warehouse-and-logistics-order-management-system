import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/vehicle/models/vehicle_model.dart';
import 'package:inventory_system/features/order/models/order_model.dart'
    as order;

class VehicleDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Vehicle>> fetchVehicles(String companyId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('vehicles')
          .where('companyId', isEqualTo: companyId)
          .get();

      return snapshot.docs.map((doc) {
        return Vehicle.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  // Add a new vehicle
  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _firestore.collection('vehicles').add(vehicle.toMap());
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  // Update a vehicle
  Future<void> updateVehicle(
      String vehicleId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).update(updateData);
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  // Delete a vehicle
  Future<void> deleteVehicle(String vehicleId) async {
    try {
      await _firestore.collection('vehicles').doc(vehicleId).delete();
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  Future<List<order.Order>> fetchOrdersByIds(List<String> orderIds) async {
    List<order.Order> orders = [];

    // Firestore only allows 'whereIn' queries with up to 10 items
    // If you have more than 10 IDs, you need to split them into chunks
    for (int i = 0; i < orderIds.length; i += 10) {
      var end = (i + 10 < orderIds.length) ? i + 10 : orderIds.length;
      var chunk = orderIds.sublist(i, end);

      var querySnapshot = await _firestore
          .collection('orders') // Replace with your orders collection name
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      var chunkOrders = querySnapshot.docs
          .map((doc) => order.Order.fromMap(doc.data(), doc.id))
          .toList();

      orders.addAll(chunkOrders);
    }

    return orders;
  }

  // Additional methods as needed...
}
