import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/academic_year.dart';
import 'package:portail_eleve/app/core/data/models/class_model.dart';
import 'package:portail_eleve/app/core/data/models/student_session.dart';
import 'package:portail_eleve/app/core/data/models/term.dart';
import 'package:portail_eleve/app/core/data/models/user_model.dart';

import '../../../core/data/models/notification_model.dart';
import '../../../core/data/models/report_card.dart';
import '../../../core/data/models/student.dart';

class ParentHomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var selectedChildIndex = 0.obs;

  var notifications = <NotificationModel>[].obs;
  var children = <Student>[].obs;
  var childrenUsers = <UserModel>[].obs;
  var currentParentUser = Rx<UserModel?>(null);
  var academicYears = <AcademicYear>[].obs;
  var terms = <Term>[].obs;
  var classes = <ClassModel>[].obs;
  var studentSessions = <StudentSession>[].obs;

  // Enhanced bulletin data using ReportCard model
  var selectedChildBulletins = <ReportCard>[].obs;
  var selectedChildNotifications = <NotificationModel>[].obs;
  var allBulletins = <ReportCard>[].obs; // For history
  var selectedAcademicYear = '2024-2025'.obs;
  var selectedPeriod = 'all'.obs;
  late ApiClient apiClient;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> onInit() async {
    super.onInit();
    apiClient = Get.find<ApiClient>();
    loadParentDashboardData();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void selectChild(int index) {
    selectedChildIndex.value = index;
    loadSelectedChildData();
  }

  Future<void> loadParentDashboardData() async {
    try {
      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 1));
      currentParentUser.value = UserModel(
        id: 2,
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'parent@example.com',
        phone: '0123456789',
        adress: '123 Rue de la Paix',
        birthday: DateTime(1975, 5, 20),
        roleId: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final marieUser = UserModel(
        id: 3,
        firstName: 'Marie',
        lastName: 'Dupont',
        email: 'marie.dupont@student.com',
        phone: '0123456789',
        adress: '123 Rue de la Paix',
        birthday: DateTime(2005, 3, 15),
        roleId: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final pierreUser = UserModel(
        id: 4,
        firstName: 'Pierre',
        lastName: 'Dupont',
        email: 'pierre.dupont@student.com',
        phone: '0123456789',
        adress: '123 Rue de la Paix',
        birthday: DateTime(2007, 8, 22),
        roleId: 3,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      childrenUsers.value = [marieUser, pierreUser];

      children.value = [
        Student(
          id: 1,
          userModelId: marieUser.id,
          matricule: '2024001',
          parentModelId: currentParentUser.value!.id,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
        Student(
          id: 2,
          userModelId: pierreUser.id,
          matricule: '2024002',
          parentModelId: currentParentUser.value!.id,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      ];
      academicYears.value = [
        AcademicYear(
          id: 1,
          label: '2024-2025',
          startDate: DateTime(2024, 9, 1).toIso8601String(),
          endDate: DateTime(2025, 6, 30).toIso8601String(),
        ),
        AcademicYear(
          id: 2,
          label: '2023-2024',
          startDate: DateTime(2023, 9, 1).toIso8601String(),
          endDate: DateTime(2024, 6, 30).toIso8601String(),
        ),
        AcademicYear(
          id: 3,
          label: '2022-2023',
          startDate: DateTime(2022, 9, 1).toIso8601String(),
          endDate: DateTime(2023, 6, 30).toIso8601String(),
        ),
      ];
      terms.value = [
        Term(id: 1, name: '1er Trimestre', academicYearId: 1),
        Term(id: 2, name: '2ème Trimestre', academicYearId: 1),
        Term(id: 3, name: '3ème Trimestre', academicYearId: 1),
        Term(id: 4, name: '1er Trimestre', academicYearId: 2),
        Term(id: 5, name: '2ème Trimestre', academicYearId: 2),
        Term(id: 6, name: '3ème Trimestre', academicYearId: 2),
      ];
      classes.value = [
        ClassModel(id: 1, name: 'Terminale S'),
        ClassModel(id: 2, name: '3ème B'),
      ];
      studentSessions.value = [
        StudentSession(
          id: 1,
          studentId: 1,
          classModelId: 1,
          academicYearId: 1,
        ), // Marie 24-25
        StudentSession(
          id: 2,
          studentId: 2,
          classModelId: 2,
          academicYearId: 1,
        ), // Pierre 24-25
        StudentSession(
          id: 3,
          studentId: 1,
          classModelId: 1,
          academicYearId: 2,
        ), // Marie 23-24
        StudentSession(
          id: 4,
          studentId: 2,
          classModelId: 2,
          academicYearId: 2,
        ), // Pierre 23-24
      ];

      loadSelectedChildData();

      loadAllBulletins();

      notifications.addAll([
        NotificationModel(
          id: 1,
          userId: currentParentUser.value!.id!,
          type: 'bulletin',
          message:
              'Nouveau bulletin disponible pour Marie - 1er Trimestre 2024-2025',
          isSent: false,
          createdAt: DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
        ),
        NotificationModel(
          id: 2,
          userId: currentParentUser.value!.id!,
          type: 'bulletin',
          message: 'Bulletin du 2ème trimestre disponible pour Pierre',
          isSent: false,
          createdAt: DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
        ),
      ]);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void loadSelectedChildData() {
    if (children.isEmpty) return;

    final selectedChild = children[selectedChildIndex.value];
    final childUser = childrenUsers.firstWhere(
      (user) => user.id == selectedChild.userModelId,
    );

    selectedChildBulletins.clear();
    selectedChildBulletins.addAll([
      ReportCard(
        id: 1,
        studentSessionId: 1, // Marie's session for 24-25
        termId: 1, // 1er Trimestre
        averageGrade: childUser.firstName == 'Marie' ? 14.5 : 12.8,
        honors: childUser.firstName == 'Marie' ? 'Assez Bien' : 'Passable',
        // rank: childUser.firstName == 'Marie' ? 8 : 15,
        path: '/bulletins/bulletin_${selectedChild.id}_T1_2024.pdf',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ReportCard(
        id: 2,
        studentSessionId: 3, // Marie's session for 23-24
        termId: 6, // 3eme Trimestre
        averageGrade: childUser.firstName == 'Marie' ? 15.2 : 13.1,
        honors: childUser.firstName == 'Marie' ? 'Bien' : 'Assez Bien',
        // rank: childUser.firstName == 'Marie' ? 6 : 12,
        path: '/bulletins/bulletin_${selectedChild.id}_T3_2023.pdf',
        createdAt: DateTime.now().subtract(const Duration(days: 120)),
      ),
    ]);

    selectedChildNotifications.clear();
    selectedChildNotifications.addAll([
      NotificationModel(
        id: selectedChild.id! + 100,
        userId: currentParentUser.value!.id!,
        type: 'bulletin',
        message:
            'Nouveau bulletin disponible pour ${childUser.firstName ?? 'l\'élève'}',
        isSent: false,
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
      ),
    ]);
  }

  void loadAllBulletins() {
    allBulletins.clear();

    for (final session in studentSessions) {
      for (final term in terms.where(
        (t) => t.academicYearId == session.academicYearId,
      )) {
        final random = DateTime.now().millisecondsSinceEpoch % 20;
        final average = 10.0 + random;
        allBulletins.add(
          ReportCard(
            id: allBulletins.length + 1,
            studentSessionId: session.id,
            termId: term.id,
            averageGrade: average,
            honors: _getMentionFromAverage(average),
            // rank: (random % 30) + 1,
            path:
                '/bulletins/bulletin_${session.studentId}_${term.name!.replaceAll(' ', '_')}.pdf',
            createdAt: DateTime.now().subtract(
              Duration(days: 30 + allBulletins.length * 10),
            ),
          ),
        );
      }
    }
  }

  String _getMentionFromAverage(double average) {
    if (average >= 16) return 'Très Bien';
    if (average >= 14) return 'Bien';
    if (average >= 12) return 'Assez Bien';
    if (average >= 10) return 'Passable';
    return 'Insuffisant';
  }

  Future<void> downloadBulletin(ReportCard bulletin) async {
    try {
      isLoading.value = true;

      final token = await _storage.read(key: 'auth_token');
      if (token == null) {
        Get.snackbar(
          'Erreur d\'authentification',
          'Veuillez vous reconnecter',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Get.snackbar(
        'Téléchargement en cours',
        'Préparation du bulletin PDF...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

      await Future.delayed(const Duration(seconds: 2));
      final term = terms.firstWhere((t) => t.id == bulletin.termId);
      final session = studentSessions.firstWhere(
        (s) => s.id == bulletin.studentSessionId,
      );
      final academicYear = academicYears.firstWhere(
        (ay) => ay.id == session.academicYearId,
      );

      Get.snackbar(
        'Téléchargement réussi',
        'Bulletin ${term.name} ${academicYear.label} téléchargé dans le dossier Téléchargements',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Erreur de téléchargement',
        'Impossible de télécharger le bulletin PDF',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<ReportCard> getFilteredBulletins() {
    final selectedChild = children[selectedChildIndex.value];
    final childSessions = studentSessions
        .where((s) => s.studentId == selectedChild.id)
        .toList();

    var filtered = allBulletins
        .where(
          (bulletin) =>
              childSessions.any((cs) => cs.id == bulletin.studentSessionId),
        )
        .toList();

    if (selectedAcademicYear.value != 'all') {
      final academicYear = academicYears.firstWhere(
        (ay) => ay.label == selectedAcademicYear.value,
        orElse: () => AcademicYear(id: -1),
      );
      if (academicYear.id != -1) {
        filtered = filtered.where((bulletin) {
          final session = studentSessions.firstWhere(
            (s) => s.id == bulletin.studentSessionId,
          );
          return session.academicYearId == academicYear.id;
        }).toList();
      }
    }

    if (selectedPeriod.value != 'all') {
      final term = terms.firstWhere(
        (t) => t.name == selectedPeriod.value,
        orElse: () => Term(id: -1),
      );
      if (term.id != -1) {
        filtered = filtered
            .where((bulletin) => bulletin.termId == term.id)
            .toList();
      }
    }

    filtered.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    return filtered;
  }

  void setAcademicYearFilter(String year) {
    selectedAcademicYear.value = year;
  }

  void setPeriodFilter(String period) {
    selectedPeriod.value = period;
  }

  List<String> getAvailableAcademicYears() {
    final years = academicYears.map((ay) => ay.label!).toSet().toList();
    years.insert(0, 'all');
    return years;
  }

  List<String> getAvailablePeriods() {
    final periods = terms.map((t) => t.name!).toSet().toList();
    periods.insert(0, 'all');
    return periods;
  }

  void goToBulletinHistory() {
    Get.toNamed(
      '/bulletin-history',
      arguments: {
        'studentId': children[selectedChildIndex.value].id,
        'studentName': selectedChildName,
      },
    );
  }

  Future<void> refreshData() async {
    await loadParentDashboardData();
  }

  String get selectedChildName {
    if (children.isEmpty) return '';
    final child = children[selectedChildIndex.value];
    final user = childrenUsers.firstWhere((u) => u.id == child.userModelId);
    return '${user.firstName} ${user.lastName}';
  }

  String get selectedChildClass {
    if (children.isEmpty) return '';
    final child = children[selectedChildIndex.value];
    final currentSession = studentSessions.firstWhere(
      (s) => s.studentId == child.id && s.academicYearId == 1, // Current AY
      orElse: () => StudentSession(),
    );
    if (currentSession.classModelId != null) {
      final currentClass = classes.firstWhere(
        (c) => c.id == currentSession.classModelId,
        orElse: () => ClassModel(),
      );
      return currentClass.name ?? 'N/A';
    }
    return 'N/A';
  }

  String get parentName {
    return currentParentUser.value != null
        ? '${currentParentUser.value!.firstName} ${currentParentUser.value!.lastName}'
        : 'Parent';
  }

  String get parentEmail {
    return currentParentUser.value?.email ?? '';
  }

  Future<void> logout() async {
    try {
      await _storage.deleteAll();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Erreur lors de la déconnexion',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
