import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grade.g.dart';

@HiveType(typeId: 16)
@JsonSerializable(fieldRename: FieldRename.snake)
class Grade {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final double? mark;

  @HiveField(2)
  final DateTime? createdAt;

  @HiveField(3)
  final DateTime? updatedAt;

  @HiveField(4)
  final int? assignementId;

  @HiveField(5)
  final int? studentSessionId;

  @HiveField(6)
  final int? termId;

  Grade({
    this.id,
    this.mark,
    this.createdAt,
    this.updatedAt,
    this.assignementId,
    this.studentSessionId,
    this.termId,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
  Map<String, dynamic> toJson() => _$GradeToJson(this);
}
