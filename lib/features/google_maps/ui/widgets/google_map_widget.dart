import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inventory_system/features/google_maps/services/google_maps_service.dart';
import 'package:inventory_system/shared/services/location_tracking_service.dart';
import 'package:inventory_system/utils/lat_lant_converter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class GoogleMapWidget extends StatefulWidget {
  final List<String> addresses;

  const GoogleMapWidget({Key? key, required this.addresses}) : super(key: key);

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  LatLng? currentLocation;
  late LocationTrackingService locationTrackingService;
  late Future<void> _mapFuture;

  @override
  void initState() {
    super.initState();
    _mapFuture = _loadMapComponents();
  }

  void _updateUserLocation(LatLng newLocation) {
    setState(() {
      currentLocation = newLocation;
      _markers.add(Marker(
        markerId: const MarkerId('user_location'),
        position: newLocation,
      ));
      // Optionally update the route or camera position
    });
  }

  Future<void> _loadMapComponents() async {
    final googleMapsService =
        Provider.of<GoogleMapsService>(context, listen: false);
    final locationTrackingService =
        Provider.of<LocationTrackingService>(context, listen: false);

    currentLocation = await locationTrackingService.getCurrentLocation();
    Set<Marker> markers = {};
    List<LatLng> waypoints = [];

    for (String address in widget.addresses) {
      LatLng location = toGoogleMapsLatLng(
          await googleMapsService.getCoordinatesFromAddress(address));
      waypoints.add(location);

      markers.add(Marker(
        markerId: MarkerId(address),
        position: location,
        infoWindow: InfoWindow(title: address),
      ));
    }

    if (waypoints.isNotEmpty) {
      List<LatLng> routePoints = toGoogleMapsLatLngList(
        await googleMapsService.getRouteCoordinates(
          toMapsToolkitLatLng(currentLocation!),
          toMapsToolkitLatLngList(waypoints),
        ),
      );

      setState(() {
        _markers = markers;
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            visible: true,
            points: routePoints,
            width: 4,
            color: Colors.blue,
          ),
        };
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _mapFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error fetching map data'));
        }

        return GoogleMap(
          padding: const EdgeInsets.only(bottom: 80.0),
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: currentLocation ??
                const LatLng(0, 0), // Use the current location if available
            zoom: 12,
          ),
          markers: _markers,
          polylines: _polylines,
        );
      },
    );
  }
}
