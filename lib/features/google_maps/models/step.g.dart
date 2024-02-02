// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Step _$StepFromJson(Map<String, dynamic> json) => Step(
      distance:
          TextValueObject.fromJson(json['distance'] as Map<String, dynamic>),
      duration:
          TextValueObject.fromJson(json['duration'] as Map<String, dynamic>),
      endLocation:
          LatLng.fromJson(json['end_location'] as Map<String, dynamic>),
      htmlInstructions: json['html_instructions'] as String,
      polyline: Polyline.fromJson(json['polyline'] as Map<String, dynamic>),
      startLocation:
          LatLng.fromJson(json['start_location'] as Map<String, dynamic>),
      travelMode: json['travel_mode'] as String,
    );

Map<String, dynamic> _$StepToJson(Step instance) => <String, dynamic>{
      'distance': instance.distance,
      'duration': instance.duration,
      'end_location': instance.endLocation,
      'html_instructions': instance.htmlInstructions,
      'polyline': instance.polyline,
      'start_location': instance.startLocation,
      'travel_mode': instance.travelMode,
    };
