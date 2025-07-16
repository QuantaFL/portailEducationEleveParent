import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/core/class_model.dart';
import 'package:portail_eleve/app/core/data/models/core/user.dart';

part 'student.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Student {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int userId;
  @HiveField(2)
  final String enrollmentDate;
  @HiveField(3)
  final int classId;
  @HiveField(4)
  final int? parentUserId;
  @HiveField(5)
  final String studentIdNumber;
  @HiveField(6)
  final User? user;
  final ClassModel? classModel;
  @HiveField(7)
  final String? createdAt;
  @HiveField(8)
  final String? updatedAt;

  Student({
    required this.id,
    required this.userId,
    this.user,
    this.classModel,
    required this.enrollmentDate,
    required this.classId,
    this.parentUserId,
    required this.studentIdNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);

  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
