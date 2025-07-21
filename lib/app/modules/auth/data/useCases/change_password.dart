import 'package:dio/dio.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';

class ChangePassword {
  final ApiClient apiClient;

  ChangePassword({required this.apiClient});

  Future<void> call(String email, String oldPassword, String newPassword) async {
    try {
      await apiClient.dio.post(
        '/auth/change-password',
        data: {
          'email': email,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );
    } on DioException {
      rethrow;
    }
  }
}
