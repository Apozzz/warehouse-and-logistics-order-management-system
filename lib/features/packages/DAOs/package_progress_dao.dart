import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventory_system/enums/package_progress_status.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';

class PackageProgressDAO {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Creates a new package progress record
  Future<PackageProgress> createPackageProgress(
      PackageProgress packageProgress) async {
    final docRef =
        await _db.collection('packageProgress').add(packageProgress.toMap());
    return packageProgress.copyWith(
        deliveryId:
            docRef.id); // Update the packageProgress with the generated ID
  }

  // Fetches package progress records by delivery ID
  Future<List<PackageProgress>> getPackageProgressByDeliveryId(
      String deliveryId) async {
    final packageProgressDocs = await _db
        .collection('packageProgress')
        .where('deliveryId', isEqualTo: deliveryId)
        .get();
    return packageProgressDocs.docs
        .map((doc) => PackageProgress.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Updates a package progress record
  Future<void> updatePackageProgress(
      String packageProgressId, Map<String, dynamic> updatedData) async {
    await _db
        .collection('packageProgress')
        .doc(packageProgressId)
        .update(updatedData);
  }

  // Deletes a package progress record by ID
  Future<void> deletePackageProgress(String packageProgressId) async {
    await _db.collection('packageProgress').doc(packageProgressId).delete();
  }

  // Fetches all package progress records for a given company
  Future<List<PackageProgress>> fetchPackageProgressByCompanyId(
      String companyId) async {
    final packageProgressDocs = await _db
        .collection('packageProgress')
        .where('companyId', isEqualTo: companyId)
        .get();
    return packageProgressDocs.docs
        .map((doc) => PackageProgress.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Fetches package progress records for a specific user within a company
  Future<List<PackageProgress>> fetchPackageProgressByCompanyIdAndUserId(
      String companyId, String userId) async {
    final packageProgressDocs = await _db
        .collection('packageProgress')
        .where('companyId', isEqualTo: companyId)
        .where('userId', isEqualTo: userId)
        .get();
    return packageProgressDocs.docs
        .map((doc) => PackageProgress.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> deletePackageProgressByDeliveryId(String deliveryId) async {
    final packageProgressDocs = await _db
        .collection('packageProgress')
        .where('deliveryId', isEqualTo: deliveryId)
        .get();

    for (var doc in packageProgressDocs.docs) {
      var packageProgress = PackageProgress.fromMap(doc.data(), doc.id);
      if (packageProgress.status != PackageProgressStatus.NotStarted) {
        throw Exception(
            'Cannot delete delivery as some packages are in progress or packaged.');
      }
    }

    for (var doc in packageProgressDocs.docs) {
      await _db.collection('packageProgress').doc(doc.id).delete();
    }
  }

  Future<List<PackageProgress>> getPackageProgressByOrderId(
      String orderId) async {
    final packageProgressDocs = await _db
        .collection('packageProgress')
        .where('orderId', isEqualTo: orderId)
        .get();

    return packageProgressDocs.docs
        .map((doc) => PackageProgress.fromMap(doc.data(), doc.id))
        .toList();
  }

  // Additional methods (e.g., fetching by orderId, productId, etc.) can be added as needed
}
