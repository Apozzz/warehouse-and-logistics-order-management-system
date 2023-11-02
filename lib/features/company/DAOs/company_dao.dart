import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/company/models/company_model.dart';

class CompanyDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Company> getCompany(String companyId) async {
    final doc = await _db.collection('companies').doc(companyId).get();
    if (doc.exists) {
      return Company.fromMap(doc.data()!, doc.id);
    } else {
      throw Exception('Company not found');
    }
  }

  Future<List<Company>> getCompanies(List<String> companyIds) async {
    final companies = <Company>[];
    for (var companyId in companyIds) {
      final companyDoc = await _db.collection('companies').doc(companyId).get();
      companies.add(Company.fromMap(companyDoc.data()!, companyDoc.id));
    }
    return companies;
  }

  // ... other methods related to Company data ...
}
