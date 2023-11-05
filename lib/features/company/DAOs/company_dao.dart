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
    final companyDocs = await _db
        .collection('companies')
        .where(FieldPath.documentId, whereIn: companyIds)
        .get();
    return companyDocs.docs
        .map((doc) => Company.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<Company> saveCompany(Company company) async {
    if (company.id.isEmpty) {
      final docRef = await _db.collection('companies').add(company.toMap());
      return company.copyWith(
          id: docRef.id); // Create a new Company instance with the generated id
    } else {
      await _db.collection('companies').doc(company.id).set(company.toMap());
      return company; // Return the original Company instance as it already has an id
    }
  }

  // ... other methods related to Company data ...
}
