import 'package:inventory_system/features/google_maps/models/lat_lng.dart';
import 'package:inventory_system/features/google_maps/models/step.dart';
import 'package:inventory_system/features/google_maps/models/text_value_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'leg.g.dart';

@JsonSerializable()
class Leg {
  final List<Step> steps;
  final TextValueObject distance;
  final TextValueObject duration;
  @JsonKey(name: 'end_address')
  final String endAddress;
  @JsonKey(name: 'end_location')
  final LatLng endLocation;
  @JsonKey(name: 'start_address')
  final String startAddress;
  @JsonKey(name: 'start_location')
  final LatLng startLocation;

  Leg({
    required this.steps,
    required this.distance,
    required this.duration,
    required this.endAddress,
    required this.endLocation,
    required this.startAddress,
    required this.startLocation,
  });

  factory Leg.fromJson(Map<String, dynamic> json) => _$LegFromJson(json);

  Map<String, dynamic> toJson() => _$LegToJson(this);
}
