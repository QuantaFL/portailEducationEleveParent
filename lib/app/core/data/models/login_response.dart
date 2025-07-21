import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/user.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  String token;
  User user;
  LoginResponse({required this.token, required this.user});
  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
