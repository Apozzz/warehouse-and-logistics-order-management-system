import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OngoingDeliverySession {
  final String id;
  final String deliveryId;
  final String userId;
  final String companyId;
  final List<LatLng> locations;
  final DateTime startTime;

  OngoingDeliverySession({
    required this.id,
    required this.deliveryId,
    required this.userId,
    required this.companyId,
    required this.locations,
    required this.startTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'deliveryId': deliveryId,
      'userId': userId,
      'companyId': companyId,
      'locations': locations
          .map((location) =>
              {'lat': location.latitude, 'lng': location.longitude})
          .toList(),
      'startTime': startTime,
    };
  }

  static OngoingDeliverySession fromMap(Map<String, dynamic> map, String id) {
    // Convert the Timestamp to a DateTime object
    var startTime = map['startTime'] is Timestamp
        ? (map['startTime'] as Timestamp).toDate()
        : DateTime.now(); // Or handle the null case as appropriate

    return OngoingDeliverySession(
      id: id,
      deliveryId: map['deliveryId'],
      userId: map['userId'],
      companyId: map['companyId'],
      locations: (map['locations'] as List)
          .map((location) => LatLng(location['lat'], location['lng']))
          .toList(),
      startTime: startTime,
    );
  }

  OngoingDeliverySession copyWith({
    String? id,
    String? deliveryId,
    String? userId,
    String? companyId,
    List<LatLng>? locations,
    DateTime? startTime,
  }) {
    return OngoingDeliverySession(
      id: id ?? this.id,
      deliveryId: deliveryId ?? this.deliveryId,
      userId: userId ?? this.userId,
      companyId: companyId ?? this.companyId,
      locations: locations ?? this.locations,
      startTime: startTime ?? this.startTime,
    );
  }
}
