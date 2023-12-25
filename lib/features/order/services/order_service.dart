import 'package:inventory_system/features/order/models/oraderitem_model.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';

class OrderService {
  final ProductDAO productDAO;

  OrderService(this.productDAO);

  Future<Set<String>> aggregateCategoriesFromOrderItems(
      List<OrderItem> orderItems) async {
    Set<String> categories = {};
    for (var item in orderItems) {
      var product = await productDAO.getProductById(item.productId);
      categories.addAll(product.categories);
    }
    return categories;
  }
}
