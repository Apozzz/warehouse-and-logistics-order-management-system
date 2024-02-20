// features/user/services/user_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/company/models/company_model.dart';
import 'package:inventory_system/features/user/DAOs/user_dao.dart';
import 'package:inventory_system/features/user/models/user_model.dart' as user;
import 'package:inventory_system/shared/services/permission_service.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final UserDAO _userDAO;
  final PermissionService _permissionService;

  UserService(this._userDAO, this._permissionService);

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
        licensesHeld: {},
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

  Future<user.User?> getUserModelByFirebaseUserId(String firebaseUserId) async {
    try {
      final doc = await _db.collection('users').doc(firebaseUserId).get();
      if (doc.exists) {
        return user.User.fromMap(doc.data()!, doc.id);
      }
      return null; // Return null if the user is not found
    } catch (e) {
      print('Error getting user model: $e');
      return null;
    }
  }

  Future<List<user.User>> fetchDriverUsersWithPackagingPermission(
      String companyId) async {
    List<user.User> companyUsers =
        await _userDAO.getUsersByCompanyId(companyId);
    List<user.User> driverUsers = [];

    for (var user in companyUsers) {
      bool hasDriverPermission = await _permissionService.checkUserPermission(
          user.id, AppPage.Packaging, PermissionType.ViewSelf);

      if (hasDriverPermission) {
        driverUsers.add(user);
      }
    }

    return driverUsers;
  }
}
