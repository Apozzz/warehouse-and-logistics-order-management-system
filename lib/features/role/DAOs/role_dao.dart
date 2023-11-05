import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/role/models/role_model.dart';

class RoleDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Role>> getRolesByIds(List<String> roleIds) async {
    final roleDocs = await _db
        .collection('roles')
        .where(FieldPath.documentId, whereIn: roleIds)
        .get();
    return roleDocs.docs
        .map((doc) => Role.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<Role> createRole(
      String name, Set<Permission> permissions, String companyId) async {
    final role = Role(
      id: '', // ID will be generated by Firestore
      name: name,
      permissions: permissions,
      companyId: companyId,
    );

    final docRef = await _db.collection('roles').add(role.toMap());
    return Role(
      id: docRef.id,
      name: role.name,
      permissions: role.permissions,
      companyId: role.companyId,
    ); // Update the role with the generated ID
  }

  Future<List<Role>> getRolesByCompanyId(String companyId) async {
    final roleDocs = await _db
        .collection('roles')
        .where('companyId', isEqualTo: companyId)
        .get();
    return roleDocs.docs
        .map((doc) => Role.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> updateRole(Role updatedRole) async {
    await _db
        .collection('roles')
        .doc(updatedRole.id)
        .update(updatedRole.toMap());
  }

  Future<void> deleteRole(String roleId) async {
    await _db.collection('roles').doc(roleId).delete();
  }
}
