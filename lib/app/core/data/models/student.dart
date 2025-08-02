import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/parent.dart';
import 'package:portail_eleve/app/core/data/models/student_session.dart';
import 'package:portail_eleve/app/core/data/models/user_model.dart';

part 'student.g.dart';

@HiveType(typeId: 19)
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Student {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String? matricule;
  @HiveField(2)
  final String? createdAt;
  @HiveField(3)
  final String? updatedAt;
  @HiveField(4)
  final int? parentModelId;
  @HiveField(5)
  final int? userModelId;
  @HiveField(6)
  final String? academicRecordsUrl;
  @HiveField(7)
  @JsonKey(name: 'userModel')
  final UserModel? userModel;
  @HiveField(8)
  @JsonKey(name: 'parentModel')
  final Parent? parentModel;
  @HiveField(9)
  final StudentSession? latestStudentSession;
  @HiveField(10)
  final int? count;
  @HiveField(11)
  @JsonKey(name: 'maleCount')
  final int? maleCount;
  @HiveField(12)
  @JsonKey(name: 'femaleCount')
  final int? femaleCount;

  Student({
    this.id,
    this.matricule,
    this.createdAt,
    this.updatedAt,
    this.parentModelId,
    this.userModelId,
    this.academicRecordsUrl,
    this.userModel,
    this.parentModel,
    this.latestStudentSession,
    this.count,
    this.maleCount,
    this.femaleCount,
  });

  factory Student.fromJson(Map<String, dynamic> json) =>
      _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
