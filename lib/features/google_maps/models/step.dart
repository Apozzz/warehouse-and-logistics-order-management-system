import 'package:inventory_system/features/google_maps/models/lat_lng.dart';
import 'package:inventory_system/features/google_maps/models/polyline.dart';
import 'package:inventory_system/features/google_maps/models/text_value_object.dart';
import 'package:json_annotation/json_annotation.dart';

part 'step.g.dart';

@JsonSerializable()
class Step {
  final TextValueObject distance;
  final TextValueObject duration;
  @JsonKey(name: 'end_location')
  final LatLng endLocation;
  @JsonKey(name: 'html_instructions')
  final String htmlInstructions;
  final Polyline polyline;
  @JsonKey(name: 'start_location')
  final LatLng startLocation;
  @JsonKey(name: 'travel_mode')
  final String travelMode;

  Step({
    required this.distance,
    required this.duration,
    required this.endLocation,
    required this.htmlInstructions,
    required this.polyline,
    required this.startLocation,
    required this.travelMode,
  });

  factory Step.fromJson(Map<String, dynamic> json) => _$StepFromJson(json);

  Map<String, dynamic> toJson() => _$StepToJson(this);
}
