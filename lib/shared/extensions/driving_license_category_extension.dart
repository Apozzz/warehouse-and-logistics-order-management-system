import 'package:inventory_system/enums/driving_category.dart';

extension DrivingLicenseCategoryExtension on DrivingLicenseCategory {
  String get description {
    switch (this) {
      case DrivingLicenseCategory.AM:
        return "Mopeds and light quadricycles";
      case DrivingLicenseCategory.A1:
        return "Light motorcycles up to 125cc";
      case DrivingLicenseCategory.A2:
        return "Medium motorcycles up to 35kW";
      case DrivingLicenseCategory.A:
        return "Motorcycles with or without a sidecar";
      case DrivingLicenseCategory.B1:
        return "Light vehicles and quadricycles";
      case DrivingLicenseCategory.B:
        return "Cars, vans, and vehicles up to 3,500kg";
      case DrivingLicenseCategory.C1:
        return "Medium-sized vehicles between 3,500kg and 7,500kg";
      case DrivingLicenseCategory.C:
        return "Heavy goods vehicles over 3,500kg";
      case DrivingLicenseCategory.D1:
        return "Minibuses with no more than 16 passenger seats";
      case DrivingLicenseCategory.D:
        return "Buses with more than 8 passenger seats";
      case DrivingLicenseCategory.BE:
        return "Vehicles in category B with a trailer";
      case DrivingLicenseCategory.C1E:
        return "Vehicles in category C1 with a trailer over 750kg";
      case DrivingLicenseCategory.CE:
        return "Vehicles in category C with a trailer";
      case DrivingLicenseCategory.D1E:
        return "Vehicles in category D1 with a trailer over 750kg";
      case DrivingLicenseCategory.DE:
        return "Vehicles in category D with a trailer";
      default:
        return "Unknown category";
    }
  }
}
