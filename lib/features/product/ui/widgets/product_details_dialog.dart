import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/sector/DAOs/sector_dao.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';
import 'package:inventory_system/features/warehouse/DAOs/warehouse_dao.dart';
import 'package:inventory_system/features/warehouse/models/warehouse_model.dart';
import 'package:provider/provider.dart';

Future<void> showProductDetails(BuildContext context, String productId) async {
  try {
    final productDAO = Provider.of<ProductDAO>(context, listen: false);
    final warehouseDAO =
        Provider.of<WarehouseDAO>(context, listen: false); // Add WarehouseDAO
    final sectorDAO =
        Provider.of<SectorDAO>(context, listen: false); // Add WarehouseDAO
    final product = await productDAO.getProductById(productId);

    Warehouse? warehouse = null;
    Sector? sector = null;

    if (product.warehouseId != null && product.warehouseId!.isNotEmpty) {
      warehouse = await warehouseDAO.getWarehouseById(product.warehouseId!);
    }

    if (product.sectorId != null && product.sectorId!.isNotEmpty) {
      sector = await sectorDAO.getSectorById(product.sectorId!);
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Product Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Name: ${product.name}'),
                Text('Description: ${product.description}'),
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                Text('Quantity: ${product.quantity}'),
                Text(
                    'Created At: ${DateFormat('yyyy-MM-dd').format(product.createdAt)}'),
                if (warehouse != null)
                  Text(
                      'Warehouse: ${warehouse.name}\nAddress:${warehouse.address}'),
                if (sector != null) Text('Warehouse Sector: ${sector.name}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error fetching product details: $e')),
    );
  }
}
