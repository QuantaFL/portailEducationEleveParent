import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/modules/auth/data/useCases/change_password.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

class ChangePasswordController extends GetxController {
  late final ChangePassword _changePasswordUseCase;
  final _storage = const FlutterSecureStorage();

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
    _changePasswordUseCase = ChangePassword(apiClient: Get.find<ApiClient>());

    // Add listeners to trigger validation on text change
    oldPasswordController.addListener(_validateOldPassword);
    newPasswordController.addListener(_validateNewPassword);
    confirmPasswordController.addListener(_validateConfirmPassword);

    // Add listeners to update UI on focus change
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
      final email = await _storage.read(key: 'user_email');
      if (email == null) {
        throw Exception('User email not found in storage.');
      }

      await _changePasswordUseCase.call(
        email,
        oldPasswordController.text,
        newPasswordController.text,
      );

      Get.snackbar(
        'Succès',
        'Mot de passe changé avec succès. Veuillez vous reconnecter.',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors du changement de mot de passe.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
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
