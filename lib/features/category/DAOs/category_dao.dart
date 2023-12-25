import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/category/models/category_model.dart';

class CategoryDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addCategory(Category category) async {
    await _db.collection('categories').add(category.toMap());
  }

  Future<void> updateCategory(
      String categoryId, Map<String, dynamic> updatedData) async {
    await _db.collection('categories').doc(categoryId).update(updatedData);
  }

  Future<void> deleteCategory(String categoryId) async {
    await _db.collection('categories').doc(categoryId).delete();
  }

  Future<List<Category>> fetchCategories(String companyId) async {
    final QuerySnapshot snapshot = await _db
        .collection('categories')
        .where('companyId', isEqualTo: companyId)
        .get();
    return snapshot.docs.map((doc) {
      return Category.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }).toList();
  }

  Future<Category> getCategoryById(String categoryId) async {
    final docSnapshot =
        await _db.collection('categories').doc(categoryId).get();
    if (docSnapshot.exists) {
      return Category.fromMap(docSnapshot.data()!, docSnapshot.id);
    }
    throw Exception('Category not found');
  }

  Future<List<Category>> getCategoriesByProductId(String productId) async {
    final querySnapshot = await _db
        .collection('categories')
        .where('productIds', arrayContains: productId)
        .get();
    return querySnapshot.docs
        .map((doc) => Category.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Additional methods as needed for handling category incompatibilities, etc.
}
