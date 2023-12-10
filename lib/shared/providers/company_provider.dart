import 'package:flutter/material.dart';
import 'package:inventory_system/features/company/DAOs/company_dao.dart';
import 'package:inventory_system/features/company/models/company_model.dart';

class CompanyProvider extends ChangeNotifier {
  final CompanyDAO _companyDAO;
  String? _companyId;
  Company? _company;

  CompanyProvider(this._companyDAO);

  String? get companyId => _companyId;
  Company? get company => _company;

  Future<void> setCompanyId(String? value) async {
    _companyId = value;
    if (value != null) {
      await _fetchCompanyDetails(value);
    } else {
      _company = null;
    }
    notifyListeners(); // Notify listeners after fetching the company
  }

  Future<void> _fetchCompanyDetails(String companyId) async {
    try {
      _company = await _companyDAO.getCompany(companyId);
    } catch (e) {
      // Handle exceptions or errors in fetching the company
      _company = null;
      print('Error fetching company details: $e');
    }
    notifyListeners(); // Notify listeners after fetching the company
  }
}
