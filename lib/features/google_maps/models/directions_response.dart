import 'package:inventory_system/features/google_maps/models/route.dart';
import 'package:json_annotation/json_annotation.dart';

part 'directions_response.g.dart';

@JsonSerializable()
class DirectionsResponse {
  final List<Route> routes;
  final String status;

  DirectionsResponse({required this.routes, required this.status});

  factory DirectionsResponse.fromJson(Map<String, dynamic> json) =>
      _$DirectionsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DirectionsResponseToJson(this);
}
