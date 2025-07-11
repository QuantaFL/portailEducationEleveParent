import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../../../core/data/models/notification_model.dart';
import '../../../core/data/models/report_card.dart';
import '../../../core/data/models/student.dart';
import '../../../core/data/models/user.dart';

class ParentHomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var selectedChildIndex = 0.obs;

  var notifications = <NotificationModel>[].obs;
  var children = <Student>[].obs;
  var currentParentUser = Rx<User?>(null);

  // Enhanced bulletin data using ReportCard model
  var selectedChildBulletins = <ReportCard>[].obs;
  var selectedChildNotifications = <NotificationModel>[].obs;
  var allBulletins = <ReportCard>[].obs; // For history
  var selectedAcademicYear = '2024-2025'.obs;
  var selectedPeriod = 'all'.obs;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
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

      // Simulate API call to get parent data
      await Future.delayed(const Duration(seconds: 1));

      // Mock parent user data with proper User model
      currentParentUser.value = User(
        id: 2,
        firstName: 'Jean',
        lastName: 'Dupont',
        email: 'parent@example.com',
        phone: '0123456789',
        password: 'hashed_password',
        address: '123 Rue de la Paix',
        dateOfBirth: '1975-05-20',
        gender: 'M',
        roleId: 2,
        // Parent role ID
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Create child users with proper User model
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
        // Student role ID
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
        // Student role ID
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      );

      // Mock children data using proper Student model
      children.value = [
        Student(
          id: 1,
          userId: marieUser.id,
          enrollmentDate: '2023-09-01',
          classId: 1,
          parentUserId: currentParentUser.value!.id,
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
          parentUserId: currentParentUser.value!.id,
          studentIdNumber: '2024002',
          user: pierreUser,
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
      ];

      // Load bulletin data for first child by default
      loadSelectedChildData();

      // Load all bulletins for history
      loadAllBulletins();

      // Mock notifications
      notifications.addAll([
        NotificationModel(
          id: 1,
          userId: currentParentUser.value!.id,
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
          userId: currentParentUser.value!.id,
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

    // Mock bulletins using proper ReportCard model
    selectedChildBulletins.clear();
    selectedChildBulletins.addAll([
      ReportCard(
        id: 1,
        studentId: selectedChild.id,
        academicYear: '2024-2025',
        period: '1er Trimestre',
        averageGradeGeneral: selectedChild.user?.firstName == 'Marie'
            ? 14.5
            : 12.8,
        mention: selectedChild.user?.firstName == 'Marie'
            ? 'Assez Bien'
            : 'Passable',
        rank: selectedChild.user?.firstName == 'Marie' ? 8 : 15,
        appreciation: 'Élève sérieux(se) avec de bons résultats',
        pdfPath: '/bulletins/bulletin_${selectedChild.id}_T1_2024.pdf',
        generatedAt: DateTime.now()
            .subtract(const Duration(days: 30))
            .toIso8601String(),
        createdAt: DateTime.now()
            .subtract(const Duration(days: 30))
            .toIso8601String(),
      ),
      ReportCard(
        id: 2,
        studentId: selectedChild.id,
        academicYear: '2023-2024',
        period: '3ème Trimestre',
        averageGradeGeneral: selectedChild.user?.firstName == 'Marie'
            ? 15.2
            : 13.1,
        mention: selectedChild.user?.firstName == 'Marie'
            ? 'Bien'
            : 'Assez Bien',
        rank: selectedChild.user?.firstName == 'Marie' ? 6 : 12,
        appreciation: 'Progression constante, continuez ainsi',
        pdfPath: '/bulletins/bulletin_${selectedChild.id}_T3_2023.pdf',
        generatedAt: DateTime.now()
            .subtract(const Duration(days: 120))
            .toIso8601String(),
        createdAt: DateTime.now()
            .subtract(const Duration(days: 120))
            .toIso8601String(),
      ),
    ]);

    // Mock notifications for selected child
    selectedChildNotifications.clear();
    selectedChildNotifications.addAll([
      NotificationModel(
        id: selectedChild.id + 100,
        userId: currentParentUser.value!.id,
        type: 'bulletin',
        message:
            'Nouveau bulletin disponible pour ${selectedChild.user?.firstName ?? 'l\'élève'}',
        isSent: false,
        createdAt: DateTime.now()
            .subtract(const Duration(hours: 1))
            .toIso8601String(),
      ),
    ]);
  }

  void loadAllBulletins() {
    // Mock historical bulletins for all children
    allBulletins.clear();

    for (final child in children) {
      // Add multiple years of bulletins
      for (String year in ['2024-2025', '2023-2024', '2022-2023']) {
        for (String period in [
          '1er Trimestre',
          '2ème Trimestre',
          '3ème Trimestre',
        ]) {
          final random = DateTime.now().millisecondsSinceEpoch % 20;
          final average = 10.0 + random;

          allBulletins.add(
            ReportCard(
              id: allBulletins.length + 1,
              studentId: child.id,
              academicYear: year,
              period: period,
              averageGradeGeneral: average,
              mention: _getMentionFromAverage(average),
              rank: (random % 30) + 1,
              appreciation: 'Bulletin de $period $year',
              pdfPath:
                  '/bulletins/bulletin_${child.id}_${period.replaceAll(' ', '_')}_${year.replaceAll('-', '_')}.pdf',
              generatedAt: DateTime.now()
                  .subtract(Duration(days: 30 + allBulletins.length * 10))
                  .toIso8601String(),
              createdAt: DateTime.now()
                  .subtract(Duration(days: 30 + allBulletins.length * 10))
                  .toIso8601String(),
            ),
          );
        }
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

  // Enhanced PDF download with proper file handling
  Future<void> downloadBulletin(ReportCard bulletin) async {
    try {
      isLoading.value = true;

      // Check if user is authenticated
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

      // Simulate PDF download process
      Get.snackbar(
        'Téléchargement en cours',
        'Préparation du bulletin PDF...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );

      await Future.delayed(const Duration(seconds: 2));

      // In a real app, this would download the actual PDF file
      // using the bulletin.pdfPath from your Laravel backend
      // Example: await ApiClient.downloadPdf(bulletin.pdfPath, token);
      // The PDF would be saved to the device's Downloads folder

      Get.snackbar(
        'Téléchargement réussi',
        'Bulletin ${bulletin.period} ${bulletin.academicYear} téléchargé dans le dossier Téléchargements',
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

  // Filter bulletins by academic year and period
  List<ReportCard> getFilteredBulletins() {
    var filtered = allBulletins
        .where(
          (bulletin) =>
              bulletin.studentId == children[selectedChildIndex.value].id,
        )
        .toList();

    if (selectedAcademicYear.value != 'all') {
      filtered = filtered
          .where(
            (bulletin) => bulletin.academicYear == selectedAcademicYear.value,
          )
          .toList();
    }

    if (selectedPeriod.value != 'all') {
      filtered = filtered
          .where((bulletin) => bulletin.period == selectedPeriod.value)
          .toList();
    }

    // Sort by most recent first
    filtered.sort(
      (a, b) => DateTime.parse(
        b.generatedAt,
      ).compareTo(DateTime.parse(a.generatedAt)),
    );

    return filtered;
  }

  // Set filters for bulletin history
  void setAcademicYearFilter(String year) {
    selectedAcademicYear.value = year;
  }

  void setPeriodFilter(String period) {
    selectedPeriod.value = period;
  }

  // Get available academic years
  List<String> getAvailableAcademicYears() {
    final years = allBulletins
        .where(
          (bulletin) =>
              bulletin.studentId == children[selectedChildIndex.value].id,
        )
        .map((bulletin) => bulletin.academicYear)
        .toSet()
        .toList();
    years.insert(0, 'all');
    return years;
  }

  // Get available periods
  List<String> getAvailablePeriods() {
    final periods = allBulletins
        .where(
          (bulletin) =>
              bulletin.studentId == children[selectedChildIndex.value].id,
        )
        .map((bulletin) => bulletin.period)
        .toSet()
        .toList();
    periods.insert(0, 'all');
    return periods;
  }

  // Navigation methods
  void goToBulletinHistory() {
    Get.toNamed(
      '/bulletin-history',
      arguments: {
        'studentId': children[selectedChildIndex.value].id,
        'studentName':
            children[selectedChildIndex.value].user?.firstName ?? 'Élève',
      },
    );
  }

  Future<void> refreshData() async {
    await loadParentDashboardData();
  }

  String get selectedChildName {
    if (children.isEmpty) return '';
    final child = children[selectedChildIndex.value];
    final user = child.user;
    return user != null ? '${user.firstName} ${user.lastName}' : 'Élève';
  }

  String get selectedChildClass {
    if (children.isEmpty) return '';
    final child = children[selectedChildIndex.value];
    return child.classId == 1 ? 'Terminale S' : '3ème B';
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
