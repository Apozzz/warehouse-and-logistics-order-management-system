import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:maps_toolkit/maps_toolkit.dart' as maps_toolkit;

maps_toolkit.LatLng toMapsToolkitLatLng(google_maps.LatLng latLng) {
  return maps_toolkit.LatLng(latLng.latitude, latLng.longitude);
}

List<maps_toolkit.LatLng> toMapsToolkitLatLngList(
    List<google_maps.LatLng> latLngList) {
  return latLngList.map((latLng) => toMapsToolkitLatLng(latLng)).toList();
}

google_maps.LatLng toGoogleMapsLatLng(maps_toolkit.LatLng latLng) {
  return google_maps.LatLng(latLng.latitude, latLng.longitude);
}

List<google_maps.LatLng> toGoogleMapsLatLngList(
    List<maps_toolkit.LatLng> latLngList) {
  return latLngList.map((latLng) => toGoogleMapsLatLng(latLng)).toList();
}
