import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'next_class.g.dart';

@JsonSerializable()
class NextClass {
  final String subject;
  final String teacher;
  final String time;
  final String color;

  NextClass({
    required this.subject,
    required this.teacher,
    required this.time,
    required this.color,
  });

  factory NextClass.fromJson(Map<String, dynamic> json) =>
      _$NextClassFromJson(json);
  Map<String, dynamic> toJson() => _$NextClassToJson(this);

  /// Returns a Color object from the hex color string.
  Color get colorValue {
    final hex = color.replaceFirst('#', '');
    if (hex.length == 6) {
      return Color(int.parse('0xFF$hex'));
    } else if (hex.length == 8) {
      return Color(int.parse('0x$hex'));
    }
    return Colors.black;
  }
}
