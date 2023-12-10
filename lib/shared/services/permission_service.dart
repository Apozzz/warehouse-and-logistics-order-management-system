import 'package:inventory_system/enums/app_page.dart';
import 'package:inventory_system/enums/permission_type.dart';
import 'package:inventory_system/features/authentication/viewmodels/auth_view_model.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/role/DAOs/role_dao.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';

class PermissionService {
  final RoleDAO roleDAO;
  final CompanyDAO companyDAO;
  final AuthViewModel authViewModel;
  final CompanyProvider companyProvider;

  PermissionService(
      this.roleDAO, this.companyDAO, this.authViewModel, this.companyProvider);

  Future<bool> hasPermission(AppPage page, PermissionType type) async {
    final userId = authViewModel.currentUser?.uid;
    final companyId = companyProvider.companyId;

    if (userId == null || companyId == null) return false;

    // Fetch the company to get the user's role ID
    final company = await companyDAO.getCompany(companyId);

    // Get the role ID for the user
    final roleId = company.userRoles[userId];
    if (roleId == null) return false;

    // Fetch the role details
    final role = await roleDAO.getRole(roleId);
    if (role == null) return false;

    // Check if the role has the required permission
    return role.hasPermission(page, type);
  }
}
