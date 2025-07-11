import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part "class_model.g.dart";

@HiveType(typeId: 4)
@JsonSerializable()
class ClassModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String academicYear;
  @HiveField(3)
  final String? createdAt;
  @HiveField(4)
  final String? updatedAt;

  ClassModel({
    required this.id,
    required this.name,
    required this.academicYear,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);

  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
