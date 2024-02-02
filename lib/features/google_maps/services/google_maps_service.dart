import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:inventory_system/features/google_maps/models/directions_response.dart';
import 'package:maps_toolkit/maps_toolkit.dart';

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
    print(url);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final directionsResponse = DirectionsResponse.fromJson(jsonResponse);
      List<LatLng> polylinePoints = [];
      double totalDistance = 0.0; // In meters
      double totalDuration = 0.0; // In seconds

      if (directionsResponse.routes.isNotEmpty) {
        final legs = directionsResponse.routes[0].legs;
        String encodedPolyline =
            directionsResponse.routes[0].overviewPolyline.points;
        List<LatLng> decodedPolylinePoints =
            PolygonUtil.decode(encodedPolyline);
        polylinePoints = decodedPolylinePoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        for (var leg in legs) {
          totalDistance += leg.distance.value;
          totalDuration += leg.duration.value;
        }

        // Optionally, you can print or store the total distance and duration
        print('Total distance: ${totalDistance / 1000} km'); // Convert to km
        print(
            'Total duration: ${totalDuration / 60} minutes'); // Convert to minutes
      } else {
        throw Exception("No routes found");
      }

      return polylinePoints;
    } else {
      throw Exception('Failed to fetch route');
    }
  }

  Future<Uint8List?> getGoogleMapsStaticMap(List<LatLng> pathPoints) async {
    try {
      // Encode the list of LatLng objects into a polyline using maps_toolkit
      String encodedPolyline = PolygonUtil.encode(
        pathPoints
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList(),
      );

      String polylineStyle = 'color:0x0000ff|weight:4';

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/staticmap?size=600x300&path=$polylineStyle|enc:$encodedPolyline&key=$apiKey');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
      print('Failed to load static map image');
    } catch (e) {
      print('Error fetching static map: $e');
    }
    return null; // Return null if there was an error
  }
}
