import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/login_response.dart';
import 'package:portail_eleve/app/modules/auth/data/useCases/auth_login.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';
import 'package:portail_eleve/app/services/hive_service.dart';

import '../../../core/data/models/user.dart';

class AuthController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;

  final RxBool isEmailValid = false.obs;
  final RxBool isPasswordValid = false.obs;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final RxBool isFormValid = false.obs;

  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;
  late final AuthLogin authLogin;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  final RxString userType = ''.obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    _setupValidation();
    _setupFocusListeners();
    _checkAutoLogin();
    authLogin = AuthLogin(apiClient: Get.find<ApiClient>());
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
    Logger log = Logger();
    if (!isFormValid.value) return;
    try {
      isLoading.value = true;

      final response = await authLogin.call(
        emailController.text,
        passwordController.text,
      );
      log.d('Login response: ${response.toJson()}');
      await _handleLoginSuccess(response);
      log.d('Login successful: ${response.toJson()}');
    } on DioException catch (e) {
      _handleLoginError(e);
    } catch (e) {
      _showSnackbar(
        'Erreur de connexion',
        'Vérifiez vos identifiants',
        Colors.red,
      );
      Logger log = Logger();
      log.e('Login error: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> _handleLoginSuccess(LoginResponse loginResponse) async {
    final Logger log = Logger();
    log.d('Login success: userId=${loginResponse}');
    final token = loginResponse.token;
    final user = loginResponse.user;

    String userType = '';
    if (user.roleId == 3) {
      userType = 'student';
    } else if (user.roleId == 4) {
      userType = 'parent';
    } else {
      log.e(
        'Unauthorized roleId: \'${user.roleId}\'. Only student (3) and parent (4) are allowed.',
      );
      return;
    }

    log.d(
      'Login success: userId=${user.id}, roleId=${user.roleId}, userType=$userType, token=${token.isNotEmpty ? '***' : 'empty'}',
    );

    try {
      await _storage.write(key: 'auth_token', value: token);
      await _storage.write(key: 'user_type', value: userType);
      await _storage.write(key: 'user_id', value: user.id.toString());
      await _storage.write(key: 'user_email', value: user.email);

      if (userType == 'student') {
        await _fetchAndStoreStudentId(user.id, token);
      }

      log.d('Token, userType, and userId saved to secure storage.');
    } catch (e) {
      log.e('Error saving to secure storage: \'${e.toString()}\'');
      return;
    }

    if (userType == 'student') {
      Get.offAllNamed(Routes.HOME);
      _showSnackbar(
        'Connexion réussie',
        'Bienvenue, ${user.firstName}!',
        Colors.green,
      );
    } else if (userType == 'parent') {
      Get.offAllNamed(Routes.PARENT_HOME);
      _showSnackbar(
        'Connexion réussie',
        'Bienvenue, ${user.firstName}!',
        Colors.green,
      );
    }
  }

  /// Fetches the actual student ID from the API based on user model ID
  Future<void> _fetchAndStoreStudentId(int userModelId, String token) async {
    final Logger log = Logger();
    try {
      final apiClient = Get.find<ApiClient>();

      final response = await apiClient.dio.get(
        '/students/$userModelId/users',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final studentId = response.data['id'];
        await _storage.write(key: 'studentId', value: studentId.toString());
        log.d(
          '✅ Actual student ID ($studentId) saved to secure storage (user_model_id: $userModelId)',
        );
      } else {
        log.e('❌ Failed to fetch student ID from API');
        await _storage.delete(key: 'studentId');
      }
    } catch (e) {
      log.e('❌ Error fetching student ID: ${e.toString()}');
      await _storage.delete(key: 'studentId');
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
    await HiveService().init();
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
