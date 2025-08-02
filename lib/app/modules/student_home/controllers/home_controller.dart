import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/data/models/next_class.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/core/data/repositories/bulletin_repository.dart';
import 'package:portail_eleve/app/core/data/repositories/student_repository.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final BulletinRepository bulletinRepository;
  final StudentRepository studentRepository;
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var student = Rx<Student?>(null);
  var recentBulletins = <ReportCard>[].obs;
  var allBulletins = <ReportCard>[].obs;

  HomeController({
    required this.bulletinRepository,
    required this.studentRepository,
  });

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  /// Loads the latest student details from the backend using the new details endpoint.
  /// Falls back to Hive if the network call fails.
  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      const storage = FlutterSecureStorage();
      final studentId = await storage.read(key: 'studentId');
      if (studentId != null) {
        try {
          final detailedStudent = await studentRepository.getStudentDetails(
            int.parse(studentId),
          );
          student.value = detailedStudent;
          await studentRepository.saveStudentToHive(detailedStudent);
        } catch (e) {
          Logger logger = Logger();
          logger.e('Failed to fetch student details from backend: $e');
          await studentRepository.getStudentFromHive(int.parse(studentId));
          student.value = studentRepository.student;
        }
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: \\${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void downloadBulletin(int bulletinId) {
    // TODO: Implement bulletin download
    Get.snackbar(
      'Téléchargement',
      'Téléchargement du bulletin en cours...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void viewBulletin(int bulletinId) {
    // TODO: Implement bulletin view
    Get.snackbar(
      'Bulletin',
      'Ouverture du bulletin...',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Déconnexion',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        content: const Text(
          'Êtes-vous sûr de vouloir vous déconnecter ?',
          style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: Color(0xFF64748B)),
            ),
          ),
          ElevatedButton(
            onPressed: () => _performLogout(),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Déconnecter',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _performLogout() async {
    try {
      Get.back();

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Color(0xFF6366F1)),
        ),
        barrierDismissible: false,
      );

      await Future.delayed(const Duration(seconds: 1));

      _clearUserData();

      Get.back();

      Get.offAllNamed(Routes.LOGIN);

      Get.snackbar(
        'Déconnexion réussie',
        'Vous avez été déconnecté avec succès',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981),
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      if (Get.isDialogOpen!) Get.back();

      Get.snackbar(
        'Erreur',
        'Une erreur est survenue lors de la déconnexion',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
        borderRadius: 12,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> _clearUserData() async {
    FlutterSecureStorage storage = const FlutterSecureStorage();
    // Clear local data
    currentIndex.value = 0;
    recentBulletins.clear();
    await storage.deleteAll();

    // Here you would typically:
    // 1. Clear SharedPreferences
    // 2. Clear secure storage (tokens, etc.)
    // 3. Clear any cached data
    // 4. Reset any other controllers

    // Example (you'll need to implement these based on your storage solution):
    // await SharedPreferences.getInstance().then((prefs) => prefs.clear());
    // await FlutterSecureStorage().deleteAll();
    // Get.delete<AuthController>(); // Clear auth controller if exists
  }

  /// Fetches the next 3 classes for the current student.
  /// Uses the enhanced repository method with API-first approach and Hive fallback.
  Future<List<NextClass>> getNextClasses() async {
    try {
      return await studentRepository.fetchNextClasses();
    } catch (e) {
      Logger().e('Error fetching next classes in controller: $e');
      // Return empty list on error to prevent UI crashes
      return [];
    }
  }
}
