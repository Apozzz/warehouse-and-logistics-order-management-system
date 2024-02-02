import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inventory_system/features/google_maps/services/google_maps_service.dart';
import 'package:inventory_system/shared/services/images_service.dart';
import 'package:inventory_system/shared/services/location_tracking_service.dart';
import 'package:inventory_system/utils/lat_lant_converter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

class DeliveryTrackingProvider with ChangeNotifier {
  final LocationTrackingService _locationTrackingService;
  final GoogleMapsService _googleMapsService;
  final ImageService _imageService;

  bool _isTracking = false;
  String? _finalRouteImageUrl;
  DateTime? _startTime;
  DateTime? _endTime;
  double? _distanceTraveled; // in kilometers
  Duration? _timeSpent;

  DeliveryTrackingProvider(this._locationTrackingService,
      this._googleMapsService, this._imageService);

  bool get isTracking => _isTracking;
  String? get finalRouteImageUrl => _finalRouteImageUrl;
  double? get distanceTraveled => _distanceTraveled;
  Duration? get timeSpent => _timeSpent;

  Future<void> startDeliveryTracking() async {
    _startTime = DateTime.now();
    await _locationTrackingService.startTracking();
    _isTracking = true;
    notifyListeners();
  }

  Future<void> endDeliveryTracking(String deliveryId) async {
    _endTime = DateTime.now();
    List<LatLng> recordedLocations =
        await _locationTrackingService.stopTrackingAndRetrieveLocations();
    Uint8List? mapImage = await _googleMapsService.getGoogleMapsStaticMap(
      toMapsToolkitLatLngList(recordedLocations),
    );

    _distanceTraveled = 0.0;
    for (int i = 0; i < recordedLocations.length - 1; i++) {
      num segmentDistance = maps_toolkit.SphericalUtil.computeDistanceBetween(
        maps_toolkit.LatLng(
          recordedLocations[i].latitude,
          recordedLocations[i].longitude,
        ),
        maps_toolkit.LatLng(
          recordedLocations[i + 1].latitude,
          recordedLocations[i + 1].longitude,
        ),
      );
      // Since computeDistanceBetween returns a num, cast it to double
      _distanceTraveled = _distanceTraveled! + segmentDistance.toDouble();
    }

    _distanceTraveled =
        double.parse((_distanceTraveled! / 1000).toStringAsFixed(2));
    _timeSpent = _endTime!.difference(_startTime!);

    if (mapImage != null) {
      String storagePath =
          "deliveries/$deliveryId/track_${DateTime.now().millisecondsSinceEpoch}.png";
      String imagePath = await _imageService.saveImage(
          mapImage, storagePath); // Assuming this method exists
      _finalRouteImageUrl = imagePath;
    }
    _isTracking = false;
    notifyListeners();
  }

  // Additional methods...
}
