import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/warehouse/models/warehouse.dart';

class WarehouseRepository {
  final CollectionReference _warehousesCollection;

  WarehouseRepository(FirebaseFirestore firestore)
      : _warehousesCollection = firestore.collection('warehouses');

  Future<void> addWarehouse(Map<String, dynamic> warehouseData) async {
    await _warehousesCollection.add(warehouseData);
  }

  Future<void> updateWarehouse(
      String id, Map<String, dynamic> updatedData) async {
    await _warehousesCollection.doc(id).update(updatedData);
  }

  Future<void> deleteWarehouse(String id) async {
    await _warehousesCollection.doc(id).delete();
  }

  Future<List<Warehouse>> fetchWarehouses() async {
    final QuerySnapshot snapshot = await _warehousesCollection.get();
    return snapshot.docs.map((doc) {
      return Warehouse.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
