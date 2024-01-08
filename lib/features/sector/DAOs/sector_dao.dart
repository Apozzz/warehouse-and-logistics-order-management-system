import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/features/sector/models/sector_model.dart';

class SectorDAO {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all sectors for a specific company
  Future<List<Sector>> fetchSectors(String companyId) async {
    try {
      final QuerySnapshot snapshot = await _firestore
          .collection('sectors')
          .where('companyId', isEqualTo: companyId)
          .get();

      return snapshot.docs.map((doc) {
        return Sector.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    } catch (e) {
      // Handle exceptions
      print(e);
      return [];
    }
  }

  // Add a new sector
  Future<void> addSector(Sector sector) async {
    try {
      await _firestore.collection('sectors').add(sector.toMap());
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  // Update a sector
  Future<void> updateSector(
      String sectorId, Map<String, dynamic> updateData) async {
    try {
      await _firestore.collection('sectors').doc(sectorId).update(updateData);
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  // Delete a sector
  Future<void> deleteSector(String sectorId) async {
    try {
      await _firestore.collection('sectors').doc(sectorId).delete();
    } catch (e) {
      // Handle exceptions
      print(e);
    }
  }

  // Additional methods as needed...
}
