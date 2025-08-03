import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/student_session.dart';

part 'user_model.g.dart';

@HiveType(typeId: 24)
@JsonSerializable(fieldRename: FieldRename.snake)
class UserModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? firstName;

  @HiveField(2)
  final String? lastName;

  @HiveField(3)
  final DateTime? birthday;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? adress;

  @HiveField(6)
  final String? phone;

  @HiveField(7)
  final int? roleId;

  @HiveField(8)
  final DateTime? createdAt;

  @HiveField(9)
  final DateTime? updatedAt;

  @HiveField(10)
  final String? profilePictureUrl;

  @HiveField(11)
  final String? nationality;

  @HiveField(12)
  final bool? isFirstLogin;

  @HiveField(13)
  final StudentSession? latestStudentSession;

  @HiveField(14)
  final String? gender;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.birthday,
    this.email,
    this.adress,
    this.phone,
    this.roleId,
    this.createdAt,
    this.updatedAt,
    this.profilePictureUrl,
    this.nationality,
    this.isFirstLogin,
    this.latestStudentSession,
    this.gender,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
