import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inventory_system/features/delivery/models/delivery_model.dart';
import 'package:inventory_system/features/delivery/services/ongoing_delivery_session_servide.dart';
import 'package:inventory_system/features/google_maps/services/google_maps_service.dart';
import 'package:inventory_system/shared/services/images_service.dart';
import 'package:inventory_system/shared/services/location_tracking_service.dart';
import 'package:inventory_system/utils/lat_lant_converter.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

class DeliveryTrackingProvider with ChangeNotifier {
  final LocationTrackingService _locationTrackingService;
  final OngoingDeliverySessionService _sessionService;
  final GoogleMapsService _googleMapsService;
  final ImageService _imageService;

  bool _isTracking = false;
  String? _finalRouteImageUrl;
  DateTime? _startTime;
  DateTime? _endTime;
  double? _distanceTraveled; // in kilometers
  Duration? _timeSpent;
  String? _currentSessionId;

  DeliveryTrackingProvider(this._locationTrackingService,
      this._googleMapsService, this._imageService, this._sessionService);

  bool get isTracking => _isTracking;
  String? get finalRouteImageUrl => _finalRouteImageUrl;
  double? get distanceTraveled => _distanceTraveled;
  Duration? get timeSpent => _timeSpent;

  Future<void> startDeliveryTracking(Delivery delivery) async {
    var existingSession =
        await _sessionService.getSessionByUser(delivery.userId);

    if (existingSession != null) {
      // Restore session state
      _currentSessionId = existingSession.id;
      _startTime = existingSession.startTime;
      var restoredLocations = existingSession.locations;
      _locationTrackingService.setRecordedLocations(restoredLocations);
    } else {
      // Start a new session if there isn't an existing one
      _startTime = DateTime.now();
      var session = await _sessionService.startSession(
          delivery.id, delivery.userId, delivery.companyId);
      _currentSessionId = session.id;
    }

    await _locationTrackingService.startTracking(
        onLocationUpdate: updateSessionLocations);
    _isTracking = true;
    notifyListeners();
  }

  Future<void> endDeliveryTracking(String deliveryId) async {
    _endTime = DateTime.now();
    List<LatLng> recordedLocations =
        await _locationTrackingService.stopTrackingAndRetrieveLocations();

    if (_currentSessionId != null) {
      await _sessionService.endSession(_currentSessionId!);
      _currentSessionId = null;
    }

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

  Future<void> updateSessionLocations(List<LatLng> locations) async {
    // Convert LatLng to a format suitable for Firestore
    if (_currentSessionId != null) {
      await _sessionService.updateSession(_currentSessionId!, {
        'locations': locations
            .map((latLng) => {'lat': latLng.latitude, 'lng': latLng.longitude})
            .toList()
      });
    }
  }

  // Additional methods...
}
