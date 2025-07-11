import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/user.dart';

part 'teacher.g.dart';

@HiveType(typeId: 3)
@JsonSerializable()
class Teacher {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int userId;
  @HiveField(6)
  final String hireDate;
  @HiveField(7)
  final User? user;
  @HiveField(8)
  final String? createdAt;
  @HiveField(9)
  final String? updatedAt;

  Teacher({
    required this.id,
    required this.userId,
    required this.hireDate,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) =>
      _$TeacherFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
