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
          "/students/${loginResponse.user.id}/details",
        );
        if (response.statusCode != 200) {
          print(response.statusCode);
        } else {
          print("ddddddddddddddddddddddd");
          // Parse the response as a List of students
          log.d(response.data);
          final student = Student.fromJson(response.data);
          // Save all students in Hive and store the first student's id in secure storage
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
          Parent parent = Parent.fromJson(response.data);
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
