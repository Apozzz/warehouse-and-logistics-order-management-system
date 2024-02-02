import 'package:json_annotation/json_annotation.dart';

part 'text_value_object.g.dart';

@JsonSerializable()
class TextValueObject {
  final String text;
  final int value;

  TextValueObject({required this.text, required this.value});

  factory TextValueObject.fromJson(Map<String, dynamic> json) =>
      _$TextValueObjectFromJson(json);

  Map<String, dynamic> toJson() => _$TextValueObjectToJson(this);
}
