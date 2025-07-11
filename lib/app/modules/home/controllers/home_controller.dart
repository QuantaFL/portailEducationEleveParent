import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

import '../../../core/data/models/notification_model.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var notifications = <NotificationModel>[].obs;
  var recentBulletins = <Map<String, dynamic>>[].obs;
  var studentInfo = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));

      // Mock student info
      studentInfo.value = {
        'name': 'Marie Dupont',
        'class': 'Terminale S',
        'establishment': 'Lycée Victor Hugo',
        'studentId': '2024001',
        'profileImage': null,
      };

      // Mock recent bulletins
      recentBulletins.addAll([
        {
          'id': '1',
          'title': 'Bulletin T1 2024-2025',
          'period': '1er Trimestre',
          'average': 14.5,
          'rank': 8,
          'totalStudents': 32,
          'date': DateTime.now().subtract(const Duration(days: 30)),
          'isDownloaded': false,
        },
        {
          'id': '2',
          'title': 'Bulletin T2 2023-2024',
          'period': '2ème Trimestre',
          'average': 15.2,
          'rank': 6,
          'totalStudents': 32,
          'date': DateTime.now().subtract(const Duration(days: 120)),
          'isDownloaded': true,
        },
        {
          'id': '3',
          'title': 'Bulletin T3 2023-2024',
          'period': '3ème Trimestre',
          'average': 16.1,
          'rank': 4,
          'totalStudents': 32,
          'date': DateTime.now().subtract(const Duration(days: 180)),
          'isDownloaded': true,
        },
      ]);

      // Mock notifications
      // notifications.addAll([
      //   NotificationModel(
      //     id: '1',
      //     title: 'Nouveau bulletin disponible',
      //     message: 'Votre bulletin du 1er trimestre est maintenant disponible',
      //     type: 'bulletin',
      //     createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      //   ),
      //   NotificationModel(
      //     id: '2',
      //     title: 'Rappel: Réunion parents-professeurs',
      //     message: 'N\'oubliez pas la réunion prévue le 15 janvier',
      //     type: 'reminder',
      //     createdAt: DateTime.now().subtract(const Duration(days: 1)),
      //   ),
      // ]);
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger les données: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void downloadBulletin(String bulletinId) {
    // TODO: Implement bulletin download
    Get.snackbar(
      'Téléchargement',
      'Téléchargement du bulletin en cours...',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void viewBulletin(String bulletinId) {
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
    notifications.clear();
    recentBulletins.clear();
    studentInfo.clear();
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
}
