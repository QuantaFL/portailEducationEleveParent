import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class_model.g.dart';

@HiveType(typeId: 15)
@JsonSerializable(fieldRename: FieldRename.snake)
class ClassModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? level;

  @HiveField(3)
  final int? count;

  @HiveField(4)
  final String? createdAt;

  @HiveField(5)
  final String? updatedAt;

  ClassModel({
    this.id,
    this.name,
    this.level,
    this.count,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) =>
      _$ClassModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
