// features/user/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/user/models/user_model.dart' as user;

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CompanyDAO _companyDAO;

  UserService(this._companyDAO);

  Future<void> createUser(User firebaseUser) async {
    final docRef = _db.collection('users').doc(firebaseUser.uid);

    // Check if user already exists
    final docSnapshot = await docRef.get();
    if (!docSnapshot.exists) {
      final newUser = user.User(
        id: firebaseUser.uid,
        name: firebaseUser.displayName ?? 'New User',
        email: firebaseUser.email ?? '',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        createdAt: DateTime.now(),
        companyIds: [],
      );
      await docRef.set(newUser.toMap());
    }
  }

  Future<void> addCompanyToUser(User user, String companyId) async {
    final userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid);
    await userDoc.update({
      'companies': FieldValue.arrayUnion([companyId]),
    });
  }

  Future<List<Company>> getUserCompanies(User user) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    final companyIds = List<String>.from(userDoc.data()?['companies'] ?? []);
    return _companyDAO.getCompanies(companyIds);
  }
}
