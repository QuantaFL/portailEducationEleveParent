import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/modules/auth/data/useCases/auth_login.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

import '../../../core/data/models/student.dart';
import '../../../core/data/models/teacher.dart';
import '../../../core/data/models/user.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final RxBool isEmailValid = false.obs;
  final RxBool isPasswordValid = false.obs;
  final RxBool isFormValid = false.obs;

  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;
  late final AuthLogin authLogin;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  final RxString userType = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Student?> currentStudent = Rx<Student?>(null);
  final Rx<Teacher?> currentTeacher = Rx<Teacher?>(null);
  final RxList<Student> parentChildren = <Student>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    authLogin = await AuthLogin(apiClient: await Get.find<ApiClient>());
    _setupValidation();
    _setupFocusListeners();
    _checkAutoLogin();
  }

  void _setupValidation() {
    emailController.addListener(() {
      isEmailValid.value = GetUtils.isEmail(emailController.text);
      _updateFormValidation();
    });

    passwordController.addListener(() {
      isPasswordValid.value = passwordController.text.length >= 6;
      _updateFormValidation();
    });
  }

  void _setupFocusListeners() {
    emailFocusNode.addListener(() {
      isEmailFocused.value = emailFocusNode.hasFocus;
    });

    passwordFocusNode.addListener(() {
      isPasswordFocused.value = passwordFocusNode.hasFocus;
    });
  }

  void _updateFormValidation() {
    isFormValid.value = isEmailValid.value && isPasswordValid.value;
  }

  void _checkAutoLogin() async {
    final token = await _storage.read(key: 'auth_token');
    final type = await _storage.read(key: 'user_type');

    if (token != null && type != null) {
      switch (type) {
        case 'parent':
          Get.offAllNamed(Routes.PARENT_HOME);
          break;
        default:
          Get.offAllNamed(Routes.HOME);
          break;
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    if (!isFormValid.value) return;
    try {
      isLoading.value = true;
      final response = await authLogin.call(
        emailController.text,
        passwordController.text,
      );
      await _handleLoginSuccess(response);
    } on DioException catch (e) {
      _handleLoginError(e);
    } catch (e) {
      _showSnackbar(
        'Erreur de connexion',
        'Vérifiez vos identifiants',
        Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _handleLoginSuccess(Map<String, dynamic> response) async {
    final token = response['data']['token'];
    final user = User.fromJson(response['data']['user']);
    final userType = user.role?.name;

    if (userType != 'parent' && userType != 'student') {
      _showSnackbar(
        'Accès non autorisé',
        'Seuls les parents et les élèves peuvent se connecter.',
        Colors.red,
      );
      return;
    }

    currentUser.value = user;
    await _storage.write(key: 'auth_token', value: token);
    await _storage.write(key: 'user_type', value: userType);
    await _storage.write(key: 'user_id', value: user.id.toString());

    _showSnackbar(
      'Connexion réussie',
      'Bienvenue dans votre portail !',
      Colors.green,
    );

    if (userType == 'parent') {
      Get.offAllNamed(Routes.PARENT_HOME);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  void _handleLoginError(DioException e) {
    final data = e.response?.data;
    if (e.response?.statusCode == 403 &&
        data['message']?.contains('First login') == true) {
      Get.toNamed(Routes.CHANGE_PASSWORD);
      _showSnackbar(
        'Premier accès',
        'Veuillez changer votre mot de passe avant de continuer.',
        Colors.orange,
      );
    } else {
      _showSnackbar(
        'Erreur de connexion',
        data?['message'] ?? 'Vérifiez vos identifiants',
        Colors.red,
      );
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      final email = emailController.text;
      await Get.find<ApiClient>().dio.post(
        '/auth/change-password',
        data: {
          'email': email,
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      );

      _showSnackbar(
        'Mot de passe changé',
        'Veuillez vous reconnecter avec votre nouveau mot de passe.',
        Colors.green,
      );
      Get.offAllNamed(Routes.LOGIN);
    } on DioException catch (e) {
      final data = e.response?.data;
      _showSnackbar(
        'Erreur',
        data?['message'] ?? 'Impossible de changer le mot de passe.',
        Colors.red,
      );
    } catch (e) {
      _showSnackbar(
        'Erreur',
        'Une erreur inattendue s\'est produite.',
        Colors.red,
      );
    }
  }

  void _showSnackbar(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  void forgotPassword() {
    if (!isEmailValid.value) {
      Get.snackbar(
        'Email requis',
        'Veuillez entrer votre adresse email',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    Get.snackbar(
      'Email envoyé',
      'Un lien de réinitialisation a été envoyé à votre email',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> logout() async {
    Future.wait([clearHiveData(), clearStorage()], eagerError: true);
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> clearHiveData() async {
    await Hive.deleteFromDisk();
  }

  Future<void> clearStorage() async {
    await _storage.deleteAll();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
