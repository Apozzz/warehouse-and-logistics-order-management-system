import 'package:cloud_firestore/cloud_firestore.dart';
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
}
