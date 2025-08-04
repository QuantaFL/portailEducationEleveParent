import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
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
    FlutterSecureStorage storage = const FlutterSecureStorage();
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    Response response;
    try {
      response = await apiClient.post(
        "/auth/login",
        data: LoginRequest(email: email, password: password).toJson(),
      );
    } on Exception catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    } catch (e) {
      throw Exception('An unexpected error occurred: ${e.toString()}');
    }

    if (response.statusCode == 200) {
      print("Login successful");
      Logger log = Logger();
      log.d(response.data);
      LoginResponse loginResponse = LoginResponse.fromJson(response.data);
      if (loginResponse.user.roleId == 3) {
        print("Fetching student data");
        Response response = await apiClient.get(
          "/students/${loginResponse.user.id}/users",
        );
        if (response.statusCode != 200) {
          print(response.statusCode);
        } else {
          print("ddddddddddddddddddddddd");
          log.d(response.data);
          final student = Student.fromJson(response.data);
          studentBox.put(student.id, student);
          await storage.write(key: 'studentId', value: student.id.toString());
        }
      } else if (loginResponse.user.roleId == 4) {
        Response response = await apiClient.get(
          "/parents/${loginResponse.user.id}",
        );
        if (response.statusCode != 200) {
          throw Exception('Failed to fetch parent data');
        } else {
          Response response = await apiClient.get(
            "/users/${loginResponse.user.id}/parents",
          );
          if (response.statusCode != 200) {
            throw Exception('Failed to fetch student data for parent');
          }
          Parent parent = Parent.fromJson(response.data);
          Response childrenResponse = await apiClient.get(
            "/parents/${parent.id}/children",
          );
          if (childrenResponse.statusCode != 200) {
            throw Exception('Failed to fetch children data for parent');
          }
          parent.children = (childrenResponse.data as List)
              .map((child) => Student.fromJson(child))
              .toList();
          parentBox.put(parent.id, parent);
          await storage.write(key: 'parentId', value: parent.id.toString());
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
