import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:location/location.dart';

class GoogleMapsService {
  final String apiKey;

  GoogleMapsService(this.apiKey);

  Future<LatLng> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse['results'] == null || jsonResponse['results'].isEmpty) {
        throw Exception("No results found");
      }
      final location = jsonResponse['results'][0]['geometry']['location'];
      print(
          'Locations and coordinates: ${location['lat']} ${location['lng']}'); // Convert to km
      return LatLng(location['lat'], location['lng']);
    } else {
      throw Exception('Failed to fetch coordinates from address');
    }
  }

  Future<List<LatLng>> getRouteCoordinates(
      LatLng origin, List<LatLng> waypoints) async {
    final waypointString =
        waypoints.map((w) => '${w.latitude},${w.longitude}').join('|');
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${origin.latitude},${origin.longitude}&waypoints=optimize:true|$waypointString&mode=driving&key=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      List<LatLng> routePoints = [];
      double totalDistance = 0.0; // In meters
      double totalDuration = 0.0; // In seconds

      if (jsonResponse['routes'] != null && jsonResponse['routes'].isNotEmpty) {
        final legs = jsonResponse['routes'][0]['legs'];
        for (var leg in legs) {
          totalDistance += leg['distance']['value'];
          totalDuration += leg['duration']['value'];

          for (var step in leg['steps']) {
            LatLng startLocation = LatLng(
                step['start_location']['lat'], step['start_location']['lng']);
            LatLng endLocation = LatLng(
                step['end_location']['lat'], step['end_location']['lng']);
            routePoints.add(startLocation);
            routePoints.add(endLocation);
          }
        }

        print('Total distance: ${totalDistance / 1000} km'); // Convert to km
        print(
            'Total duration: ${totalDuration / 60} minutes'); // Convert to minutes
      }

      return routePoints;
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  Future<LatLng> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return const LatLng(0, 0);
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return const LatLng(0, 0);
      }
    }

    locationData = await location.getLocation();
    return LatLng(locationData.latitude ?? 0.0, locationData.longitude ?? 0.0);
  }
}
