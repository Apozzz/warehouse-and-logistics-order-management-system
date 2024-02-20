import 'package:inventory_system/enums/delivery_status.dart';
import 'package:inventory_system/enums/package_progress_status.dart';
import 'package:inventory_system/features/delivery/DAOs/delivery_dao.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/order/models/order_model.dart';
import 'package:inventory_system/features/packages/DAOs/package_progress_dao.dart';
import 'package:inventory_system/features/packages/models/package_progress.dart';

class PackagingService {
  final PackageProgressDAO packageProgressDAO;
  final DeliveryDAO deliveryDAO;

  PackagingService(this.packageProgressDAO, this.deliveryDAO);

  Future<void> updatePackagesForDelivery(Delivery updatedDelivery,
      List<Order> updatedOrders, String assignedUserId) async {
    var delivery = updatedDelivery;

    if (updatedDelivery.id.isEmpty) {
      delivery = await deliveryDAO.createDelivery(updatedDelivery);
    }

    var existingPackageMap = await fetchExistingPackageProgressMap(delivery.id);
    await updateOrCreatePackageProgress(
        existingPackageMap, updatedOrders, delivery.id, assignedUserId);
  }

  Future<Map<String, PackageProgress>> fetchExistingPackageProgressMap(
      String deliveryId) async {
    var existingPackageProgressList =
        await packageProgressDAO.getPackageProgressByDeliveryId(deliveryId);
    return {
      for (var p in existingPackageProgressList)
        '${p.orderId}_${p.productId}': p
    };
  }

  Future<void> updateOrCreatePackageProgress(
      Map<String, PackageProgress> existingPackageMap,
      List<Order> updatedOrders,
      String deliveryId,
      String assignedUserId) async {
    for (var order in updatedOrders) {
      for (var product in order.items) {
        var packageKey = '${order.id}_${product.productId}';
        if (existingPackageMap.containsKey(packageKey)) {
          var existingPackage = existingPackageMap[packageKey]!;
          var updatedData = existingPackage
              .copyWith(quantity: product.quantity, userId: assignedUserId)
              .toMap();
          await packageProgressDAO.updatePackageProgress(
              existingPackage.id, updatedData);
        } else {
          var newPackageProgress = PackageProgress(
              id: '',
              companyId: order.companyId,
              deliveryId: deliveryId,
              orderId: order.id,
              productId: product.productId,
              userId: assignedUserId,
              scanCode: product.scanCode,
              quantity: product.quantity,
              packagedQuantity: 0,
              status: PackageProgressStatus.NotStarted);
          await packageProgressDAO.createPackageProgress(newPackageProgress);
        }
      }
    }
  }

  Future<List<Delivery>> fetchPackagingDeliveries(String companyId,
      {String? userId}) async {
    List<Delivery> deliveries =
        await deliveryDAO.fetchPackagingDeliveries(companyId);

    // Filter deliveries by userId if provided
    return userId?.isNotEmpty ?? false
        ? deliveries.where((delivery) => delivery.userId == userId).toList()
        : deliveries;
  }

  Future<List<Delivery>> fetchTransportingDeliveries(String companyId,
      {String? userId}) async {
    List<Delivery> deliveries =
        await deliveryDAO.fetchTransportingDeliveries(companyId);

    // Filter deliveries by userId if provided
    return userId?.isNotEmpty ?? false
        ? deliveries.where((delivery) => delivery.userId == userId).toList()
        : deliveries;
  }

  Future<List<Delivery>> fetchFinishedDeliveries(String companyId,
      {String? userId}) async {
    List<Delivery> deliveries =
        await deliveryDAO.fetchFinishedDeliveries(companyId);

    // Filter deliveries by userId if provided
    return userId?.isNotEmpty ?? false
        ? deliveries.where((delivery) => delivery.userId == userId).toList()
        : deliveries;
  }

  Future<void> scanAndProcessPackage(String deliveryId, String barcode) async {
    final packageProgressList =
        await packageProgressDAO.getPackageProgressByDeliveryId(deliveryId);

    for (var package in packageProgressList) {
      if (package.scanCode == barcode) {
        if (package.status == PackageProgressStatus.Packaged) {
          // If already packaged, return or notify caller
          // TODO: change back to return, when testing is not needed. It's currently
          // changed to continue; because of trouble of getting many different barcodes in Virtual Device
          //return;
          continue;
        }

        int newPackagedQuantity = package.packagedQuantity + 1;
        PackageProgressStatus newStatus = package.status;

        if (newPackagedQuantity >= package.quantity) {
          newStatus = PackageProgressStatus.Packaged;
        } else {
          newStatus = PackageProgressStatus.InProgress;
        }

        await packageProgressDAO.updatePackageProgress(package.id, {
          'packagedQuantity': newPackagedQuantity,
          'status': newStatus.index,
        });

        await deliveryDAO.updateDelivery(
            deliveryId, {'status': DeliveryStatus.Preparing.index});

        break;
      }
    }
  }

  Future<void> declineAllPackagesForOrder(
      String orderId, String declineReason) async {
    List<PackageProgress> packages =
        await packageProgressDAO.getPackageProgressByOrderId(orderId);

    for (var package in packages) {
      await packageProgressDAO.updatePackageProgress(package.id, {
        'status': PackageProgressStatus.Declined.index,
        'declineReason': declineReason, // Include declineReason in the update
        'packagedQuantity': 0,
      });
    }
  }

  Future<void> restoreAllPackagesForOrder(String orderId) async {
    List<PackageProgress> packages =
        await packageProgressDAO.getPackageProgressByOrderId(orderId);

    // Batch update to restore all packages
    for (var package in packages) {
      await packageProgressDAO.updatePackageProgress(package.id, {
        'status': PackageProgressStatus.NotStarted.index,
        'declineReason': null,
        'packagedQuantity': 0,
      });
    }
  }

  // ... other methods like fetchPackageProgressByCompanyId, fetchPackageProgressByCompanyIdAndUserId
}
