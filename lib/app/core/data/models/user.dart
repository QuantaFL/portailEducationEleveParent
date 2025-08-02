import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/data/models/role.dart';

part 'user.g.dart';

@HiveType(typeId: 0)
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
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
  final String address;
  @HiveField(7)
  final String dateOfBirth;
  @HiveField(8)
  final String gender;
  @HiveField(9)
  final int roleId;
  @HiveField(10)
  final Role? role;
  @HiveField(11)
  final bool isFirstLogin;
  @HiveField(12)
  final String? profilePictureUrl;
  @HiveField(13)
  final String? rememberToken;
  @HiveField(14)
  final String? createdAt;
  @HiveField(15)
  final String? updatedAt;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.roleId,
    required this.address,
    required this.dateOfBirth,
    required this.gender,
    required this.isFirstLogin,
    this.profilePictureUrl,
    this.role,
    this.rememberToken,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final logger = Logger();
    logger.d('Parsing User from json: \n\t' + json.toString());
    return User(
      id: json['id'] as int,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      roleId: json['role_id'] as int? ?? 0,
      address: json['address'] as String? ?? json['adress'] as String? ?? '',
      dateOfBirth:
          json['date_of_birth'] as String? ?? json['birthday'] as String? ?? '',
      gender: json['gender'] as String? ?? '',
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      isFirstLogin: json['isFirstLogin'] as bool? ?? false,
      profilePictureUrl: json['profile_picture_url'] as String?,
      rememberToken: json['remember_token'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
