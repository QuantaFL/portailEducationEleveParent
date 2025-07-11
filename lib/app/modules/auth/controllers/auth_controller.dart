import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../../../core/data/models/role.dart';
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

  // Add reactive focus states
  final RxBool isEmailFocused = false.obs;
  final RxBool isPasswordFocused = false.obs;

  final emailFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Add user type tracking
  final RxString userType = ''.obs; // 'student' or 'parent'
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<Student?> currentStudent = Rx<Student?>(null);
  final Rx<Teacher?> currentTeacher = Rx<Teacher?>(null);
  final RxList<Student> parentChildren = <Student>[].obs;

  @override
  void onInit() {
    super.onInit();
    _setupValidation();
    _setupFocusListeners();
    _checkAutoLogin();
  }

  void _setupValidation() {
    // Email validation
    emailController.addListener(() {
      isEmailValid.value = GetUtils.isEmail(emailController.text);
      _updateFormValidation();
    });

    // Password validation
    passwordController.addListener(() {
      isPasswordValid.value = passwordController.text.length >= 6;
      _updateFormValidation();
    });
  }

  void _setupFocusListeners() {
    // Add focus listeners to update reactive variables
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
          Get.offAllNamed('/parent-home');
          break;
        case 'teacher':
          Get.offAllNamed('/teacher-home');
          break;
        case 'student':
        default:
          Get.offAllNamed('/home');
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

      // Simulate API call to your Laravel backend
      await Future.delayed(const Duration(seconds: 2));

      // Mock API response - replace with actual API call
      if (emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        // Mock user data based on email pattern
        Map<String, dynamic> userData;

        if (emailController.text.contains('parent')) {
          userData = await _mockParentLogin();
        } else {
          userData = await _mockStudentLogin();
        }

        // Store auth token and user data
        await _storage.write(key: 'auth_token', value: userData['token']);
        await _storage.write(key: 'user_type', value: userData['type']);
        await _storage.write(
          key: 'user_id',
          value: userData['user'].id.toString(),
        );

        currentUser.value = userData['user'];

        Get.snackbar(
          'Connexion réussie',
          'Bienvenue dans votre portail !',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );

        // Navigate based on user role
        switch (userData['type']) {
          case 'parent':
            Get.offAllNamed('/parent-home');
            break;
          case 'teacher':
            Get.offAllNamed('/teacher-home');
            break;
          case 'student':
          default:
            Get.offAllNamed('/home');
            break;
        }
      } else {
        throw Exception('Identifiants invalides');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur de connexion',
        'Vérifiez vos identifiants',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> _mockStudentLogin() async {
    final user = User(
      id: 1,
      firstName: 'Marie',
      lastName: 'Dupont',
      email: emailController.text,
      phone: '0123456789',
      password: 'hashed_password',
      address: '123 Rue de la Paix',
      dateOfBirth: '2005-03-15',
      gender: 'F',
      roleId: 3,
      role: Role(id: 3, name: 'student'),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final student = Student(
      id: 1,
      userId: user.id,
      enrollmentDate: '2023-09-01',
      classId: 1,
      parentUserId: 2,
      studentIdNumber: '2024001',
      user: user,
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    currentStudent.value = student;

    return {
      'token': 'student_token_123',
      'type': 'student',
      'user': user,
      'student': student,
    };
  }

  Future<Map<String, dynamic>> _mockParentLogin() async {
    final user = User(
      id: 2,
      firstName: 'Jean',
      lastName: 'Dupont',
      email: emailController.text,
      phone: '0123456789',
      password: 'hashed_password',
      address: '123 Rue de la Paix',
      dateOfBirth: '1975-05-20',
      gender: 'M',
      roleId: 2,
      role: Role(id: 2, name: 'parent'),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final marieUser = User(
      id: 3,
      firstName: 'Marie',
      lastName: 'Dupont',
      email: 'marie.dupont@student.com',
      phone: '0123456789',
      password: 'hashed_password',
      address: '123 Rue de la Paix',
      dateOfBirth: '2005-03-15',
      gender: 'F',
      roleId: 3,
      role: Role(id: 3, name: 'student'),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final pierreUser = User(
      id: 4,
      firstName: 'Pierre',
      lastName: 'Dupont',
      email: 'pierre.dupont@student.com',
      phone: '0123456789',
      password: 'hashed_password',
      address: '123 Rue de la Paix',
      dateOfBirth: '2007-08-22',
      gender: 'M',
      roleId: 3,
      role: Role(id: 3, name: 'student'),
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );

    final children = [
      Student(
        id: 1,
        userId: marieUser.id,
        enrollmentDate: '2023-09-01',
        classId: 1,
        parentUserId: user.id,
        studentIdNumber: '2024001',
        user: marieUser,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      Student(
        id: 2,
        userId: pierreUser.id,
        enrollmentDate: '2023-09-01',
        classId: 2,
        parentUserId: user.id,
        studentIdNumber: '2024002',
        user: pierreUser,
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    ];

    parentChildren.value = children;

    return {
      'token': 'parent_token_456',
      'type': 'parent',
      'user': user,
      'children': children,
    };
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
    Get.offAllNamed('/login');
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
