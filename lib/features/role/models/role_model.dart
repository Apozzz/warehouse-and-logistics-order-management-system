import 'package:flutter/foundation.dart';

enum Permission {
  ManageUsers,
  ViewFinancialData,
}

class Role {
  final String id;
  final String name;
  final Set<Permission> permissions;
  final String companyId;

  Role({
    required this.id,
    required this.name,
    required this.permissions,
    required this.companyId,
  });

  // Factory constructor to create a Role instance from a Map
  factory Role.fromMap(Map<String, dynamic> data, String id) {
    return Role(
      id: id,
      name: data['name'] ?? '',
      permissions: (data['permissions'] as List<dynamic>?)
              ?.map((e) => Permission.values[e])
              .toSet() ??
          {},
      companyId: data['companyId'] ?? '',
    );
  }

  // Method to convert a Role instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'permissions': permissions.map((e) => e.index).toList(),
      'companyId': companyId,
    };
  }

  // Utility method to check if the role has a specific permission
  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

  // Utility method to add a permission to the role
  Role addPermission(Permission permission) {
    return copyWith(permissions: Set.from(permissions)..add(permission));
  }

  // Utility method to remove a permission from the role
  Role removePermission(Permission permission) {
    return copyWith(permissions: Set.from(permissions)..remove(permission));
  }

  // Creates a copy of the Role instance with altered fields
  Role copyWith({
    String? id,
    String? name,
    Set<Permission>? permissions,
    String? companyId,
  }) {
    return Role(
      id: id ?? this.id,
      name: name ?? this.name,
      permissions: permissions ?? this.permissions,
      companyId: companyId ?? this.companyId,
    );
  }

  // Check if Role is empty
  bool get isEmpty =>
      id.isEmpty && name.isEmpty && permissions.isEmpty && companyId.isEmpty;

  // Check if Role is not empty
  bool get isNotEmpty => !isEmpty;

  // Overriding toString for better readability during debugging
  @override
  String toString() {
    return 'Role{id: $id, name: $name, permissions: $permissions, companyId: $companyId}';
  }

  // Overriding equality and hashCode
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Role &&
        other.id == id &&
        other.name == name &&
        setEquals(other.permissions, permissions) &&
        other.companyId == companyId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        permissions.hashCode ^
        companyId.hashCode;
  }

  // Static method to create an empty Role instance
  static Role empty() {
    return Role(
      id: '',
      name: '',
      permissions: <Permission>{},
      companyId: '',
    );
  }
}
