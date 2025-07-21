import 'package:dio/dio.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/login_response.dart';
import 'package:portail_eleve/app/core/data/models/parent.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';

import '../../../../core/data/models/login_request.dart';

class AuthLogin {
  final ApiClient apiClient;

  AuthLogin({required this.apiClient});

  Box<Student> studentBox = Hive.box<Student>('students');
  Box<Parent> parentBox = Hive.box<Parent>('parents');

  Future<LoginResponse> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    Response response = await apiClient.post(
      "/auth/login",
      data: LoginRequest(email: email, password: password).toJson(),
    );

    if (response.statusCode == 200) {
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.user.roleId == 3) {
        Response response = await apiClient.get(
          "/students/${loginResponse.user.id}",
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to fetch student data');
        } else {
          Student student = Student.fromJson(response.data);
          studentBox.put(student.id, student);
        }
      } else if (loginResponse.user.roleId == 4) {
        Response response = await apiClient.get(
          "/parents/${loginResponse.user.id}",
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to fetch parent data');
        } else {
          Parent parent = Parent.fromJson(response.data);
          parentBox.put(parent.id, parent);
        }
      }
      return loginResponse;
    } else {
      throw Exception(
        'Login failed: ${response.data['message'] ?? 'Unknown error'}',
      );
    }
  }
}
