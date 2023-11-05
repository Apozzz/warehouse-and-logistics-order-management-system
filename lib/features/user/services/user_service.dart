// features/user/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/models/user_model.dart' as user;

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final CompanyDAO _companyDAO;
  final UserDAO _userDAO;

  UserService(this._companyDAO, this._userDAO);

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
      await _userDAO.createUser(newUser);
    }
  }

  Future<void> addCompanyToUser(User user, String companyId) async {
    await _userDAO.addCompanyToUser(user.uid, companyId);
  }

  Future<List<Company>> getUserCompanies(User user) async {
    return _userDAO.getUserCompanies(user.uid);
  }
}
