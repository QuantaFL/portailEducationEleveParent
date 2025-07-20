
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/auth/controllers/auth_controller.dart';

class ChangePasswordController extends GetxController {
  final AuthController authController = Get.find();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> changePassword() async {
    isLoading.value = true;
    try {
      await authController.changePassword(
        oldPasswordController.text,
        newPasswordController.text,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    super.onClose();
  }
}
