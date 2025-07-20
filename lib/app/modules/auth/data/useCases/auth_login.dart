import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';

class AuthLogin {
  final ApiClient apiClient;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  AuthLogin({required this.apiClient});

  Future<Map<String, dynamic>> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password cannot be empty');
    }
    Response response = await apiClient.post(
      "/auth/login",
      data: {"email": email, "password": password},
    );

    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception(
        'Login failed: ${response.data['message'] ?? 'Unknown error'}',
      );
    }
  }
}
