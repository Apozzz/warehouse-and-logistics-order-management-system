import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/permissions/models/role_permission_model.dart';

class Role {
  final String id;
  final String name;
  final List<RolePermission> rolePermissions;
  final String companyId;

  Role({
    required this.id,
    required this.name,
    required this.rolePermissions,
    required this.companyId,
  });

  factory Role.fromMap(Map<String, dynamic> data, String id) {
    List<RolePermission> rolePermissions = (data['rolePermissions'] as List)
        .map((rpData) => RolePermission.fromMap(rpData))
        .toList();

    return Role(
      id: id,
      name: data['name'] ?? '',
      rolePermissions: rolePermissions,
      companyId: data['companyId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    var rolePermissionsData = rolePermissions.map((rp) => rp.toMap()).toList();

    return {
      'name': name,
      'rolePermissions': rolePermissionsData,
      'companyId': companyId,
    };
  }

  bool hasPermission(AppPage page, PermissionType type) {
    return rolePermissions
        .any((rp) => rp.page == page && rp.permissions[type] == true);
  }

  Role copyWith({
    String? id,
    String? name,
    List<RolePermission>? permissions,
    String? companyId,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      rolePermissions: permissions ?? rolePermissions,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  String toString() {
    return 'Role{id: $id, name: $name, permissions: $rolePermissions, companyId: $companyId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Role &&
        other.id == id &&
        other.name == name &&
        other.rolePermissions == rolePermissions &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    // Use Iterable.fold to combine hash codes of RolePermission list
    final permissionsHashCode = rolePermissions.fold<int>(
        0, (previousValue, element) => previousValue ^ element.hashCode);
    return id.hashCode ^
        name.hashCode ^
        permissionsHashCode ^
        companyId.hashCode;
  }

  static Role empty() {
    return Role(
      id: '',
      name: '',
      rolePermissions: [],
      companyId: '',
    );
  }

  bool get isEmpty =>
      id.isEmpty &&
      name.isEmpty &&
      rolePermissions.isEmpty &&
      companyId.isEmpty;

  // Check if Role instance is not empty
  bool get isNotEmpty => !isEmpty;
}
