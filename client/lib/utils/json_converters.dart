// lib/utils/bool_from_int_converter.dart
import 'package:json_annotation/json_annotation.dart';

class BoolFromIntConverter implements JsonConverter<bool, int> {
  const BoolFromIntConverter();

  @override
  bool fromJson(int json) {
    return json == 1;
  }

  @override
  int toJson(bool object) {
    return object ? 1 : 0;
  }
}