import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart';

@HiveType(typeId: 21)
@JsonSerializable(fieldRename: FieldRename.snake)
class Subject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? level;

  @HiveField(3)
  final int? coefficient;

  @HiveField(4)
  final DateTime? createdAt;

  @HiveField(5)
  final DateTime? updatedAt;

  Subject({
    this.id,
    this.name,
    this.level,
    this.coefficient,
    this.createdAt,
    this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}