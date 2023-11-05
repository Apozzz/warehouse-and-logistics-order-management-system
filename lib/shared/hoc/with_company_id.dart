import 'package:flutter/widgets.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';

Future<T?> withCompanyId<T>(
    BuildContext context, Future<T> Function(String) action) async {
  final companyId = context.read<CompanyProvider>().companyId;
  if (companyId != null) {
    return await action(companyId);
  } else {
    // Optionally handle the case where companyId is null, e.g., show a dialog
    return null;
  }
}
