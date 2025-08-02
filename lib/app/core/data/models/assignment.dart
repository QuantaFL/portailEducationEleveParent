import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assignment.g.dart';

@HiveType(typeId: 14)
@JsonSerializable(fieldRename: FieldRename.snake)
class Assignment {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final DateTime? createdAt;

  @HiveField(2)
  final DateTime? updatedAt;

  @HiveField(3)
  final int? teacherId;

  @HiveField(4)
  final int? classModelId;

  @HiveField(5)
  final int? subjectId;

  @HiveField(6)
  final int? termId;

  @HiveField(7)
  final String? dayOfWeek;

  @HiveField(8)
  final String? startTime;

  @HiveField(9)
  final String? endTime;

  Assignment({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.teacherId,
    this.classModelId,
    this.subjectId,
    this.termId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}
