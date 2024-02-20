import 'dart:async';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class LocationTrackingService {
  Location location = Location();
  List<LatLng> recordedLocations = [];
  StreamSubscription<LocationData>? _locationSubscription;
  bool _isPermissionGranted = false;

  Future<void> _checkPermissions() async {
    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        throw Exception('Location service not enabled');
      }
    }

    PermissionStatus permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }

    _isPermissionGranted = permissionGranted == PermissionStatus.granted;
  }

  Future<void> startTracking({
    required Function(List<LatLng>) onLocationUpdate,
  }) async {
    if (!_isPermissionGranted) {
      await _checkPermissions();
    }

    if (_isPermissionGranted) {
      _locationSubscription =
          location.onLocationChanged.listen((LocationData currentLocation) {
        LatLng newLatLng =
            LatLng(currentLocation.latitude!, currentLocation.longitude!);
        recordedLocations.add(newLatLng);
        onLocationUpdate(recordedLocations);
        // Notify any listeners that the location updated, if necessary
      });
    } else {
      throw Exception('Location permission not granted');
    }
  }

  Future<List<LatLng>> stopTrackingAndRetrieveLocations() async {
    await _locationSubscription?.cancel();
    List<LatLng> locations =
        List.from(recordedLocations); // Make a copy of the locations

    // CHECKING
    locations.forEach((element) {
      print(element);
    });

    recordedLocations.clear(); // Clear the recorded locations

    return locations; // Return the copy for further processing
  }

  Future<LatLng> getCurrentLocation() async {
    LocationData locationData;

    if (!_isPermissionGranted) {
      await _checkPermissions();
    }

    if (_isPermissionGranted) {
      locationData = await location.getLocation();
      return LatLng(
          locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
    } else {
      throw Exception('Location permission not granted');
    }
  }

  void setRecordedLocations(List<LatLng> locations) {
    recordedLocations = locations;
  }
}
