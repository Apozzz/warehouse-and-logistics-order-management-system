import 'package:flutter/widgets.dart';
import 'package:inventory_system/shared/providers/company_provider.dart';
import 'package:provider/provider.dart';

extension CompanyProviderExtension on BuildContext {
  CompanyProvider get companyProvider {
    final provider = read<CompanyProvider>();
    if (provider.companyId == null) {
      throw Exception('No company selected');
    }
    return provider;
  }
}
