import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'academic_year.dart';
import 'class_model.dart';

part 'student_session.g.dart';

@HiveType(typeId: 20)
@JsonSerializable(fieldRename: FieldRename.snake)
class StudentSession {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final int? studentId;

  @HiveField(2)
  final int? classModelId;

  @HiveField(3)
  final int? academicYearId;

  @HiveField(4)
  final String? createdAt;

  @HiveField(5)
  final String? updatedAt;

  @HiveField(6)
  final String? justificatifUrl;

  @HiveField(7)
  final ClassModel? classModel;

  @HiveField(8)
  final AcademicYear? academicYear;

  StudentSession({
    this.id,
    this.studentId,
    this.classModelId,
    this.academicYearId,
    this.createdAt,
    this.updatedAt,
    this.justificatifUrl,
    this.classModel,
    this.academicYear,
  });

  factory StudentSession.fromJson(Map<String, dynamic> json) =>
      _$StudentSessionFromJson(json);
  Map<String, dynamic> toJson() => _$StudentSessionToJson(this);
}
