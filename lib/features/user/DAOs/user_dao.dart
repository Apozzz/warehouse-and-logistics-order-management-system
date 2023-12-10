import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/user/models/user_model.dart';

class UserDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<User> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    return User.fromMap(doc.data()!, doc.id);
  }

  Future<void> addCompanyToUser(String userId, String companyId) async {
    await _db.collection('users').doc(userId).update({
      'companyIds': FieldValue.arrayUnion([companyId]),
    });
  }

  Future<List<Company>> getUserCompanies(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    final companyIds = List<String>.from(userDoc.data()?['companyIds'] ?? []);
    if (companyIds.isEmpty) {
      return [];
    }
    final companyDocs = await _db
        .collection('companies')
        .where(FieldPath.documentId, whereIn: companyIds)
        .get();
    return companyDocs.docs
        .map((doc) => Company.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<User>> getUsersByIds(List<String> userIds) async {
    final userDocs = await _db
        .collection('users')
        .where(FieldPath.documentId, whereIn: userIds)
        .get();
    return userDocs.docs
        .map((doc) => User.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<int> getTotalUsers(String companyId) async {
    try {
      final QuerySnapshot snapshot = await _db
          .collection('users')
          .where('companyIds',
              arrayContains:
                  companyId) // Assuming 'companyIds' is an array field
          .get();

      return snapshot.docs.length;
    } catch (e) {
      print('Error getting total users: $e');
      // Decide on how you want to handle this error.
      // For example, you could return -1 or re-throw the error after logging it.
      throw Exception('Failed to get total users');
    }
  }
}
