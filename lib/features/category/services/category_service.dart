import 'package:inventory_system/features/category/DAOs/category_dao.dart';
import 'package:inventory_system/features/category/models/category_model.dart';
import 'package:inventory_system/features/order/DAOs/order_dao.dart';
import 'package:inventory_system/features/product/DAOs/product_dao.dart';
import 'package:inventory_system/features/vehicle/DAOs/vehicle_dao.dart';

class CategoryService {
  final CategoryDAO _categoryDAO;
  final ProductDAO _productDAO;
  final OrderDAO _orderDAO;
  final VehicleDAO _vehicleDAO;
  Map<String, Category> _cachedCategories = {};
  bool _isCacheInitialized = false;
  // Other DAOs as needed (e.g., ProductDAO, OrderDAO, VehicleDAO)

  CategoryService(
      this._categoryDAO, this._productDAO, this._orderDAO, this._vehicleDAO);

  Future<void> initializeCategories(String companyId) async {
    List<Category> categories = await _categoryDAO.fetchCategories(companyId);
    _cachedCategories = {for (var cat in categories) cat.id: cat};
    _isCacheInitialized = true;
  }

  Set<Category> getCategoriesFromIds(Set<String> categoryIds) {
    if (!_isCacheInitialized) {
      throw Exception("Categories have not been initialized.");
    }
    return categoryIds
        .map((id) => _cachedCategories[id])
        .whereType<Category>()
        .toSet();
  }

  Future<bool> areCategoriesCompatible(Set<String> categoryIds) async {
    for (String categoryId in categoryIds) {
      var category = await _categoryDAO.getCategoryById(categoryId);
      for (String incompatibleId in category.incompatibleCategories) {
        if (categoryIds.contains(incompatibleId)) {
          return false; // Found an incompatibility
        }
      }
    }
    return true; // All selected categories are compatible
  }

  bool areCategoriesCompatibleSync(Set<String> categoryIds) {
    if (!_isCacheInitialized) {
      throw Exception("Categories have not been initialized.");
    }

    for (String categoryId in categoryIds) {
      var category = _cachedCategories[categoryId];
      if (category == null) continue;
      //print(category.name + " : PASSED CATEGORY NULL CHECK");
      for (String incompatibleId in category.incompatibleCategories) {
        // print(
        //     '${categoryIds.contains(incompatibleId)}  : DOES CONTAIN ??? ---- ${incompatibleId} ----- ${category.id} -- current cat ID');
        if (categoryIds.contains(incompatibleId)) {
          return false; // Found an incompatibility
        }
      }
    }
    return true; // All selected categories are compatible
  }

  // Method to check if a product can have certain categories
  Future<bool> canProductHaveCategories(
      String productId, Set<String> categoryIds) async {
    // Fetch the product's existing categories (if any)
    var existingCategories =
        await _categoryDAO.getCategoriesByProductId(productId);
    // Combine existing categories with new ones
    var combinedCategories = Set<String>.from(existingCategories)
      ..addAll(categoryIds);
    // Check for compatibility
    return await areCategoriesCompatible(combinedCategories);
  }

  // Method to check if an order can include products with certain categories
  Future<bool> canOrderIncludeProducts(
      String orderId, Set<String> productIds) async {
    for (var productId in productIds) {
      var product = await _productDAO.getProductById(productId);

      if (product.categories == null) {
        continue;
      }

      if (!await canProductHaveCategories(productId, product.categories!)) {
        return false; // Product has incompatible categories
      }
    }
    return true; // All products are compatible within the order
  }

  // Method to check if a vehicle can carry orders with certain categories
  Future<bool> canVehicleCarryOrders(
      String vehicleId, List<String> orderIds) async {
    var vehicle = await _vehicleDAO.getVehicleById(vehicleId);

    for (var orderId in orderIds) {
      var order = await _orderDAO.getOrderById(orderId);

      if (order == null) {
        continue;
      }

      if (!vehicle.allowedCategories.containsAll(order.categories)) {
        return false; // Vehicle cannot carry this order
      }
    }
    return true; // Vehicle can carry all orders
  }

  // Additional methods to manage category incompatibilities
  // For example, a method to add or remove incompatibilities between categories
}
