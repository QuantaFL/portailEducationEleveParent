import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/data/models/parent.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/core/data/models/user_model.dart';

class ProfileController extends GetxController {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final Logger _logger = Logger();

  final RxBool isLoading = false.obs;
  final Rx<Student?> currentStudent = Rx<Student?>(null);
  final Rx<Parent?> currentParent = Rx<Parent?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString userType = ''.obs;

  @override
  void onInit() {
    super.onInit();

    final arguments = Get.arguments;
    if (arguments != null && arguments['parentUser'] != null) {
      _loadParentUserFromArguments(arguments['parentUser'] as UserModel);
    } else if (arguments != null && arguments['parent'] != null) {
      _loadParentFromArguments(arguments['parent'] as Parent);
    } else {
      _loadUserData();
    }
  }

  void _loadParentUserFromArguments(UserModel parentUser) {
    try {
      isLoading.value = true;

      currentUser.value = parentUser;
      userType.value = 'parent';

      _logger.d(
        'Parent user data loaded from arguments: ${parentUser.firstName} ${parentUser.lastName}',
      );
      _logger.d('Parent email: ${parentUser.email}');
      _logger.d('Parent phone: ${parentUser.phone}');
      _logger.d('Parent address: ${parentUser.adress}');
    } catch (e) {
      _logger.e('Error loading parent user from arguments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _loadParentFromArguments(Parent parent) {
    try {
      isLoading.value = true;

      currentParent.value = parent;
      currentUser.value = parent.userModel;
      userType.value = 'parent';

      _logger.d(
        'Parent data loaded from arguments: ${parent.userModel?.firstName} ${parent.userModel?.lastName}',
      );
    } catch (e) {
      _logger.e('Error loading parent from arguments: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;

      final storedUserType = await _storage.read(key: 'user_type');
      final storedUserId = await _storage.read(key: 'user_id');

      if (storedUserType == null || storedUserId == null) {
        _logger.w('No user data found in storage');
        return;
      }

      userType.value = storedUserType;
      final userId = int.parse(storedUserId);

      if (storedUserType == 'student') {
        await _loadStudentData(userId);
      } else if (storedUserType == 'parent') {
        await _loadParentData(userId);
      }

      _logger.d('Profile data loaded for $storedUserType with ID: $userId');
    } catch (e) {
      _logger.e('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStudentData(int userId) async {
    try {
      final studentsBox = await Hive.openBox<Student>('students');

      _logger.d('Loading student data for userId: $userId');
      _logger.d('Students box length: ${studentsBox.length}');

      for (var student in studentsBox.values) {
        _logger.d(
          'Student ID: ${student.id}, UserModelId: ${student.userModelId}, User: ${student.userModel?.firstName} ${student.userModel?.lastName}',
        );
        _logger.d(
          'Parent Model: ${student.parentModel?.userModel?.firstName} ${student.parentModel?.userModel?.lastName}',
        );
      }

      final students = studentsBox.values.where((s) => s.userModelId == userId);

      if (students.isNotEmpty) {
        final student = students.first;
        currentStudent.value = student;
        currentUser.value = student.userModel;

        _logger.d('Student data loaded successfully:');
        _logger.d(
          '- Student: ${student.userModel?.firstName} ${student.userModel?.lastName}',
        );
        _logger.d('- Matricule: ${student.matricule}');
        _logger.d(
          '- Parent: ${student.parentModel?.userModel?.firstName} ${student.parentModel?.userModel?.lastName}',
        );
        _logger.d('- Parent Email: ${student.parentModel?.userModel?.email}');
        _logger.d('- Class: ${student.latestStudentSession?.classModel?.name}');

        update();
      } else {
        _logger.w('No student found with user ID: $userId');
        _logger.w(
          'Available student userModelIds: ${studentsBox.values.map((s) => s.userModelId).toList()}',
        );
      }
    } catch (e) {
      _logger.e('Error loading student data: $e');
      _logger.e('Stack trace: ${StackTrace.current}');
    }
  }

  Future<void> _loadParentData(int userId) async {
    try {
      final parentsBox = await Hive.openBox<Parent>('parents');

      final parents = parentsBox.values.where((p) => p.userModel?.id == userId);

      if (parents.isNotEmpty) {
        final parent = parents.first;
        currentParent.value = parent;
        currentUser.value = parent.userModel;
        _logger.d(
          'Parent data loaded: ${parent.userModel?.firstName} ${parent.userModel?.lastName}',
        );
      } else {
        _logger.w('No parent found with user ID: $userId');
      }
    } catch (e) {
      _logger.e('Error loading parent data: $e');
    }
  }

  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  String getFullName() {
    final user = currentUser.value;
    if (user?.firstName != null && user?.lastName != null) {
      return '${user!.firstName} ${user.lastName}';
    }
    return 'Non défini';
  }

  String getEmail() {
    return currentUser.value?.email ?? 'Non défini';
  }

  String getPhoneNumber() {
    return currentUser.value?.phone ?? 'Non défini';
  }

  String getMatricule() {
    if (userType.value == 'student') {
      return currentStudent.value?.matricule ?? 'Non défini';
    }
    return 'Non applicable';
  }

  String getBirthDate() {
    final birthDate = currentUser.value?.birthday;
    if (birthDate != null) {
      return birthDate.toLocal().toIso8601String().split('T')[0];
    }
    return 'Non défini';
  }

  String getGender() {
    final gender = currentUser.value?.gender;
    if (gender != null) {
      switch (gender.toLowerCase()) {
        case 'm':
        case 'male':
        case 'masculin':
          return 'Masculin';
        case 'f':
        case 'female':
        case 'féminin':
          return 'Féminin';
        default:
          return gender;
      }
    }
    return 'Non défini';
  }

  String getAddress() {
    return currentUser.value?.adress ?? 'Non défini';
  }

  String getCurrentClass() {
    if (userType.value == 'student') {
      return currentStudent.value?.latestStudentSession?.classModel?.name ??
          'Classe non définie';
    }
    return 'Non applicable';
  }

  String getAcademicYear() {
    if (userType.value == 'student') {
      return currentStudent.value?.latestStudentSession?.academicYear?.label ??
          '2024-2025';
    }
    return 'Non applicable';
  }

  String getStudentStatus() {
    if (userType.value == 'student') {
      return currentStudent.value?.id != null
          ? 'Élève actif'
          : 'Statut inconnu';
    }
    return 'Non applicable';
  }

  String getParentName() {
    if (userType.value == 'student') {
      final parent = currentStudent.value?.parentModel?.userModel;
      if (parent?.firstName != null && parent?.lastName != null) {
        return '${parent!.firstName} ${parent.lastName}';
      }
    }
    return 'Non défini';
  }

  String getParentEmail() {
    if (userType.value == 'student') {
      return currentStudent.value?.parentModel?.userModel?.email ??
          'Non défini';
    }
    return 'Non applicable';
  }

  String getParentPhone() {
    if (userType.value == 'student') {
      return currentStudent.value?.parentModel?.userModel?.phone ??
          'Non défini';
    }
    return 'Non applicable';
  }

  String getInitials() {
    final user = currentUser.value;
    if (user?.firstName != null && user?.lastName != null) {
      return '${user!.firstName?[0]}${user.lastName?[0]}'.toUpperCase();
    }
    return 'ÉT';
  }

  bool get isStudent => userType.value == 'student';

  bool get isParent => userType.value == 'parent';

  void editProfile() {
    Get.snackbar(
      'Modification',
      'Fonctionnalité de modification en cours de développement',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF6366F1),
      colorText: const Color(0xFFFFFFFF),
      borderRadius: 12,
      margin: const EdgeInsets.all(16),
    );
  }
}
