import 'package:flutter/foundation.dart';

class CompanyProvider extends ChangeNotifier {
  String? _companyId;

  String? get companyId => _companyId;

  set companyId(String? value) {
    _companyId = value;
    notifyListeners(); // Notify listeners whenever companyId changes
  }
}
