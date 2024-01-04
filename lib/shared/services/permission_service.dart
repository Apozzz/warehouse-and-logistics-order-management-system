import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/shared/models/view_permissions.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';

class PermissionService {
  final RoleDAO roleDAO;
  final CompanyDAO companyDAO;
  final AuthViewModel authViewModel;
  final CompanyProvider companyProvider;

  PermissionService(
      this.roleDAO, this.companyDAO, this.authViewModel, this.companyProvider);

  Future<bool> _checkPermission(AppPage page, PermissionType type) async {
    final userId = authViewModel.currentUser?.uid;
    final companyId = companyProvider.companyId;

    if (userId == null || companyId == null) return false;

    final company = await companyDAO.getCompany(companyId);
    final roleId = company.userRoles[userId];
    if (roleId == null) return false;

    final role = await roleDAO.getRole(roleId);
    return role?.hasPermission(page, type) ?? false;
  }

  Future<bool> hasPermission(AppPage page, PermissionType type) async {
    return _checkPermission(page, type);
  }

  Future<ViewPermissions> fetchViewPermissions(AppPage page) async {
    bool hasViewSelf = await hasPermission(page, PermissionType.ViewSelf);
    bool hasViewAll = await hasPermission(page, PermissionType.ViewAll);

    return ViewPermissions(viewAll: hasViewAll, viewSelf: hasViewSelf);
  }

  Future<bool> checkUserPermission(
      String userId, AppPage page, PermissionType type) async {
    final companyId = companyProvider.companyId;
    if (companyId == null) return false;

    final company = await companyDAO.getCompany(companyId);
    final roleId = company.userRoles[userId];
    if (roleId == null) return false;

    final role = await roleDAO.getRole(roleId);
    return role?.hasPermission(page, type) ?? false;
  }
}
