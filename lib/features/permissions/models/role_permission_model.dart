import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';

class RolePermission {
  final AppPage page;
  final Map<PermissionType, bool> permissions;

  RolePermission({required this.page, required this.permissions});

  Map<String, dynamic> toMap() {
    return {
      'page': page.name, // Using the enum's name instead of index
      'permissions': permissions.map((type, value) =>
          MapEntry(type.name, value)) // Again, using the enum's name
    };
  }

  static RolePermission fromMap(Map<String, dynamic> map) {
    var page = AppPage.values
        .byName(map['page']); // Convert the string back to an enum
    var permissions = {
      for (var type in PermissionType.values)
        type: map['permissions'][type.name] as bool? ??
            false // Using the enum's name for lookup
    };
    return RolePermission(page: page, permissions: permissions);
  }

  @override
  String toString() {
    // Convert permissions map to a string like 'Manage: Yes, View: No'
    final permissionsStr = permissions.entries
        .map((entry) => '${entry.key.name}: ${entry.value ? "Yes" : "No"}')
        .join(', ');

    return '${page.name}: $permissionsStr';
  }
}
