import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:portail_eleve/app/core/data/models/core/class_model.dart';
import 'package:portail_eleve/app/core/data/models/core/student.dart';
import 'session.dart';

part 'student_session.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(explicitToJson: true)
class StudentSession {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final Session session;

  @HiveField(2)
  final Student student;

  @HiveField(4)
  final ClassModel classe;

  @HiveField(5)
  @JsonKey(name: 'is_leave')
  final bool isLeave;

  @HiveField(6)
  @JsonKey(name: 'is_active')
  final bool isActive;

  @HiveField(7)
  @JsonKey(name: 'enroll_date')
  final DateTime enrollDate;

  @HiveField(8)
  final String status;

  StudentSession({
    this.id,
    required this.session,
    required this.student,
    required this.classe,
    required this.isLeave,
    required this.isActive,
    required this.enrollDate,
    required this.status,
  });

  factory StudentSession.fromJson(Map<String, dynamic> json) =>
      _$StudentSessionFromJson(json);

  Map<String, dynamic> toJson() => _$StudentSessionToJson(this);
}
