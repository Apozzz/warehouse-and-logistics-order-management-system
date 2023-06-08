import 'package:inventory_system/imports.dart';

class ProductSerializer {
  String serializeProductIds(List<String> productIds) {
    return productIds.join(',');
  }

  List<String> unserializeProductIds(String serializedProductIds) {
    return serializedProductIds.split(',');
  }
}
