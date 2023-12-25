import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/constants/product_fields.dart';
import 'package:inventory_system/features/product/models/product_model.dart';

class ProductDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addProduct(Product product) async {
    await _db.collection('products').add(product.toMap());
  }

  Future<void> updateProduct(
      String productId, Map<String, dynamic> updatedData) async {
    await _db.collection('products').doc(productId).update(updatedData);
  }

  Future<void> deleteProduct(String productId) async {
    await _db.collection('products').doc(productId).delete();
  }

  Future<List<Product>> fetchProducts(String companyId) async {
    final QuerySnapshot snapshot = await _db
        .collection('products')
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) {
      return Product.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<Product?> getProductByBarcode(String barcode) async {
    Query query = _db
        .collection('products')
        .where(ProductFields.scanCode, isEqualTo: barcode)
        .limit(1);

    try {
      final QuerySnapshot snapshot = await query.get();
      if (snapshot.docs.isNotEmpty) {
        // Assuming barcode is unique, there should be only one match.
        return Product.fromMap(
            snapshot.docs.first.data() as Map<String, dynamic>,
            snapshot.docs.first.id);
      } else {
        // No product found with this barcode.
        return null;
      }
    } catch (e) {
      print('Error fetching product by barcode: $e');
      return null;
    }
  }

  Future<int> getTotalProducts(String companyId) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('products')
          .where('companyId', isEqualTo: companyId)
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting total products: $e');
      // Decide on how you want to handle this error.
      // For example, you could return -1 or re-throw the error after logging it.
      throw Exception('Failed to get total products');
    }
  }

  Future<Product> getProductById(String productId) async {
    final docSnapshot = await _db.collection('products').doc(productId).get();
    if (docSnapshot.exists) {
      return Product.fromMap(docSnapshot.data()!, docSnapshot.id);
    }
    throw Exception('Product not found');
  }
}
