import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/modules/auth/controllers/auth_controller.dart';

class ChangePasswordController extends GetxController {
  final AuthController authController = Get.find<AuthController>();

  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final oldPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();
  final confirmPasswordFocusNode = FocusNode();

  final isLoading = false.obs;
  final isOldPasswordObscured = true.obs;
  final isNewPasswordObscured = true.obs;
  final isConfirmPasswordObscured = true.obs;

  final isOldPasswordValid = false.obs;
  final isNewPasswordValid = false.obs;
  final isConfirmPasswordValid = false.obs;
  final isFormValid = false.obs;
  final passwordsDoNotMatch = false.obs;

  @override
  void onInit() {
    super.onInit();
    oldPasswordController.addListener(_validateOldPassword);
    newPasswordController.addListener(_validateNewPassword);
    confirmPasswordController.addListener(_validateConfirmPassword);

    oldPasswordFocusNode.addListener(update);
    newPasswordFocusNode.addListener(update);
    confirmPasswordFocusNode.addListener(update);
  }

  void _validateOldPassword() {
    isOldPasswordValid.value = oldPasswordController.text.length >= 6;
    _updateFormState();
  }

  void _validateNewPassword() {
    isNewPasswordValid.value = newPasswordController.text.length >= 6;
    _validateConfirmPassword();
  }

  void _validateConfirmPassword() {
    final newPassword = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (confirmPassword.isNotEmpty) {
      passwordsDoNotMatch.value = newPassword != confirmPassword;
      isConfirmPasswordValid.value =
          !passwordsDoNotMatch.value && isNewPasswordValid.value;
    } else {
      passwordsDoNotMatch.value = false;
      isConfirmPasswordValid.value = false;
    }
    _updateFormState();
  }

  void _updateFormState() {
    isFormValid.value =
        isOldPasswordValid.value &&
        isNewPasswordValid.value &&
        isConfirmPasswordValid.value;
  }

  Future<void> changePassword() async {
    if (!isFormValid.value) return;

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
    confirmPasswordController.dispose();
    oldPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
    super.onClose();
  }
}
