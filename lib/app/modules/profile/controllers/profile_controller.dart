import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/data/models/parent.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/core/data/models/user_model.dart';

/// Controller for managing profile data and operations
class ProfileController extends GetxController {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final Logger _logger = Logger();

  // Reactive variables
  final RxBool isLoading = false.obs;
  final Rx<Student?> currentStudent = Rx<Student?>(null);
  final Rx<Parent?> currentParent = Rx<Parent?>(null);
  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxString userType = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  /// Loads user data from storage and Hive database
  Future<void> _loadUserData() async {
    try {
      isLoading.value = true;

      // Get user info from secure storage
      final storedUserType = await _storage.read(key: 'user_type');
      final storedUserId = await _storage.read(key: 'user_id');

      if (storedUserType == null || storedUserId == null) {
        _logger.w('No user data found in storage');
        return;
      }

      userType.value = storedUserType;
      final userId = int.parse(storedUserId);

      // Load data based on user type
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

  /// Loads student data from Hive database
  Future<void> _loadStudentData(int userId) async {
    try {
      final studentsBox = await Hive.openBox<Student>('students');

      _logger.d('Loading student data for userId: $userId');
      _logger.d('Students box length: ${studentsBox.length}');

      // Log all students in the box for debugging
      for (var student in studentsBox.values) {
        _logger.d(
          'Student ID: ${student.id}, UserModelId: ${student.userModelId}, User: ${student.userModel?.firstName} ${student.userModel?.lastName}',
        );
        _logger.d(
          'Parent Model: ${student.parentModel?.userModel?.firstName} ${student.parentModel?.userModel?.lastName}',
        );
      }

      // Find student by user model ID
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

        // Force UI update
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

  /// Loads parent data from Hive database
  Future<void> _loadParentData(int userId) async {
    try {
      final parentsBox = await Hive.openBox<Parent>('parents');

      // Find parent by user model ID - Parent doesn't have userModelId directly
      // We need to check the userModel's id instead
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

  /// Refreshes user data from storage and database
  Future<void> refreshUserData() async {
    await _loadUserData();
  }

  /// Gets the current user's full name
  String getFullName() {
    final user = currentUser.value;
    if (user?.firstName != null && user?.lastName != null) {
      return '${user!.firstName} ${user.lastName}';
    }
    return 'Non défini';
  }

  /// Gets the current user's email
  String getEmail() {
    return currentUser.value?.email ?? 'Non défini';
  }

  /// Gets the current user's phone number
  String getPhoneNumber() {
    return currentUser.value?.phone ?? 'Non défini';
  }

  /// Gets the student's matricule (student ID)
  String getMatricule() {
    if (userType.value == 'student') {
      return currentStudent.value?.matricule ?? 'Non défini';
    }
    return 'Non applicable';
  }

  /// Gets the current user's birth date
  String getBirthDate() {
    final birthDate = currentUser.value?.birthday;
    if (birthDate != null) {
      return birthDate.toLocal().toIso8601String().split('T')[0];
    }
    return 'Non défini';
  }

  /// Gets the current user's gender
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

  /// Gets the current user's address
  String getAddress() {
    return currentUser.value?.adress ?? 'Non défini';
  }

  /// Gets the current class information
  String getCurrentClass() {
    if (userType.value == 'student') {
      return currentStudent.value?.latestStudentSession?.classModel?.name ??
          'Classe non définie';
    }
    return 'Non applicable';
  }

  /// Gets the academic year
  String getAcademicYear() {
    if (userType.value == 'student') {
      return currentStudent.value?.latestStudentSession?.academicYear?.label ??
          '2024-2025';
    }
    return 'Non applicable';
  }

  /// Gets the student status
  String getStudentStatus() {
    if (userType.value == 'student') {
      return currentStudent.value?.id != null
          ? 'Élève actif'
          : 'Statut inconnu';
    }
    return 'Non applicable';
  }

  /// Gets the parent's name
  String getParentName() {
    if (userType.value == 'student') {
      final parent = currentStudent.value?.parentModel?.userModel;
      if (parent?.firstName != null && parent?.lastName != null) {
        return '${parent!.firstName} ${parent.lastName}';
      }
    }
    return 'Non défini';
  }

  /// Gets the parent's email
  String getParentEmail() {
    if (userType.value == 'student') {
      return currentStudent.value?.parentModel?.userModel?.email ??
          'Non défini';
    }
    return 'Non applicable';
  }

  /// Gets the parent's phone
  String getParentPhone() {
    if (userType.value == 'student') {
      return currentStudent.value?.parentModel?.userModel?.phone ??
          'Non défini';
    }
    return 'Non applicable';
  }

  /// Gets user initials for avatar
  String getInitials() {
    final user = currentUser.value;
    if (user?.firstName != null && user?.lastName != null) {
      return '${user!.firstName?[0]}${user.lastName?[0]}'.toUpperCase();
    }
    return 'ÉT';
  }

  /// Checks if current user is a student
  bool get isStudent => userType.value == 'student';

  /// Checks if current user is a parent
  bool get isParent => userType.value == 'parent';

  /// Handles profile editing action
  void editProfile() {
    // TODO: Navigate to profile editing screen
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
