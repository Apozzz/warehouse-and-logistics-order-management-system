import 'package:flutter/foundation.dart';
import 'package:inventory_system/features/warehouse/models/warehouse.dart';
import 'package:inventory_system/features/warehouse/repositories/warehouse_repository.dart';

class WarehouseService extends ChangeNotifier {
  final WarehouseRepository _warehouseRepository;
  final ValueNotifier<List<Warehouse>> warehouses = ValueNotifier([]);

  WarehouseService(this._warehouseRepository);

  Future<void> addWarehouse(Map<String, dynamic> warehouseData) async {
    await _warehouseRepository.addWarehouse(warehouseData);
    fetchWarehouses();
  }

  Future<void> updateWarehouse(
      String warehouseId, Map<String, dynamic> updatedData) async {
    await _warehouseRepository.updateWarehouse(warehouseId, updatedData);
    fetchWarehouses();
  }

  Future<void> deleteWarehouse(String warehouseId) async {
    await _warehouseRepository.deleteWarehouse(warehouseId);
    fetchWarehouses();
  }

  Future<List<Warehouse>> fetchWarehouses() async {
    final fetchedWarehouses = await _warehouseRepository.fetchWarehouses();
    warehouses.value = fetchedWarehouses;
    return fetchedWarehouses;
  }
}
