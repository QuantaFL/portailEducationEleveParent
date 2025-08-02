import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@HiveType(typeId: 22)
@JsonSerializable(fieldRename: FieldRename.snake)
class Teacher {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final DateTime? hireDate;

  @HiveField(2)
  final DateTime? createdAt;

  @HiveField(3)
  final DateTime? updatedAt;

  @HiveField(4)
  final int? userModelId;

  @HiveField(5)
  final int? count;

  Teacher({
    this.id,
    this.hireDate,
    this.createdAt,
    this.updatedAt,
    this.userModelId,
    this.count,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
