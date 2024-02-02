// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leg.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Leg _$LegFromJson(Map<String, dynamic> json) => Leg(
      steps: (json['steps'] as List<dynamic>)
          .map((e) => Step.fromJson(e as Map<String, dynamic>))
          .toList(),
      distance:
          TextValueObject.fromJson(json['distance'] as Map<String, dynamic>),
      duration:
          TextValueObject.fromJson(json['duration'] as Map<String, dynamic>),
      endAddress: json['end_address'] as String,
      endLocation:
          LatLng.fromJson(json['end_location'] as Map<String, dynamic>),
      startAddress: json['start_address'] as String,
      startLocation:
          LatLng.fromJson(json['start_location'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LegToJson(Leg instance) => <String, dynamic>{
      'steps': instance.steps,
      'distance': instance.distance,
      'duration': instance.duration,
      'end_address': instance.endAddress,
      'end_location': instance.endLocation,
      'start_address': instance.startAddress,
      'start_location': instance.startLocation,
    };
