import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';

class WarehouseDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addWarehouse(Warehouse warehouse) async {
    await _db.collection('warehouses').add(warehouse.toMap());
  }

  Future<void> updateWarehouse(
      String warehouseId, Map<String, dynamic> updatedData) async {
    await _db.collection('warehouses').doc(warehouseId).update(updatedData);
  }

  Future<void> deleteWarehouse(String warehouseId) async {
    await _db.collection('warehouses').doc(warehouseId).delete();
  }

  Future<List<Warehouse>> fetchWarehouses(String companyId) async {
    final QuerySnapshot snapshot = await _db
        .collection('warehouses')
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) {
      return Warehouse.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }
}
