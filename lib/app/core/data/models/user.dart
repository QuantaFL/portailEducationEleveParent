import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/role.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class User {
  @HiveField(0)
  final int id;
  @HiveField(2)
  final String firstName;
  @HiveField(3)
  final String lastName;
  @HiveField(4)
  final String email;
  @HiveField(5)
  final String phone;
  @HiveField(6)
  final String password;
  @HiveField(7)
  final String address;
  @HiveField(8)
  final String dateOfBirth;
  @HiveField(9)
  final String gender;
  @HiveField(10)
  final int roleId;
  @HiveField(11)
  final Role? role;
  @HiveField(12)
  final String? rememberToken;
  @HiveField(13)
  final String? createdAt;
  @HiveField(14)
  final String? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.password,
    required this.roleId,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    this.role,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
