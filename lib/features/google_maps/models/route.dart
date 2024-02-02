import 'package:inventory_system/features/google_maps/models/leg.dart';
import 'package:inventory_system/features/google_maps/models/overview_polyline.dart';
import 'package:json_annotation/json_annotation.dart';

part 'route.g.dart';

@JsonSerializable()
class Route {
  final List<Leg> legs;
  @JsonKey(name: 'overview_polyline')
  final OverviewPolyline overviewPolyline;
  final String summary;

  Route(
      {required this.legs,
      required this.overviewPolyline,
      required this.summary});

  factory Route.fromJson(Map<String, dynamic> json) => _$RouteFromJson(json);

  Map<String, dynamic> toJson() => _$RouteToJson(this);
}
