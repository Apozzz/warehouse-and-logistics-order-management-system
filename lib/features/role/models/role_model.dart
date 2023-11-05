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

  // You might have methods for adding, removing or checking permissions
  bool hasPermission(Permission permission) {
    return permissions.contains(permission);
  }

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

  static Role empty() {
    return Role(
      id: '',
      name: '',
      permissions: <Permission>{},
      companyId: '',
    );
  }
}

enum Permission {
  ManageUsers,
  ViewFinancialData,
}
