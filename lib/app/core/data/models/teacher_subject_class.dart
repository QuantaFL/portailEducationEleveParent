import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teacher_subject_class.g.dart';

@HiveType(typeId: 6)
@JsonSerializable()
class TeacherSubjectClass {
  @HiveField(0)
  final int teacherId;
  @HiveField(1)
  final int subjectId;
  @HiveField(2)
  final int classId;
  @HiveField(3)
  final String? createdAt;
  @HiveField(4)
  final String? updatedAt;

  TeacherSubjectClass({
    required this.teacherId,
    required this.subjectId,
    required this.classId,
    this.createdAt,
    this.updatedAt,
  });

  factory TeacherSubjectClass.fromJson(Map<String, dynamic> json) =>
      _$TeacherSubjectClassFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherSubjectClassToJson(this);
}
