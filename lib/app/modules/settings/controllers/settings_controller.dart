import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../auth/controllers/auth_controller.dart';

class SettingsController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final RxBool pushNotifications = true.obs;
  final RxBool emailNotifications = false.obs;
  final RxBool darkMode = false.obs;
  final RxString language = 'français'.obs;
  final RxBool biometricLogin = false.obs;

  final RxMap<String, dynamic> userProfile = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
    loadSettings();
  }

  Future<void> loadUserProfile() async {
    isLoading.value = true;
    try {
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 500));
      userProfile.value = {
        'name': 'John Doe',
        'email': 'john.doe@example.com',
        'class': 'Terminale S',
        'studentId': '2024001',
        'phone': '+33 6 12 34 56 78',
        'address': '123 Rue de l\'École, 75001 Paris',
        'birthDate': '15/03/2007',
        'parentEmail': 'parent@example.com',
      };
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger le profil');
    } finally {
      isLoading.value = false;
    }
  }

  void loadSettings() {
    // Load settings from local storage
    // This would typically use SharedPreferences or similar
    pushNotifications.value = true;
    emailNotifications.value = false;
    darkMode.value = false;
    language.value = 'français';
    biometricLogin.value = false;
  }

  void togglePushNotifications(bool value) {
    pushNotifications.value = value;
    saveSettings();
    Get.snackbar(
      'Notifications',
      value ? 'Notifications activées' : 'Notifications désactivées',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleEmailNotifications(bool value) {
    emailNotifications.value = value;
    saveSettings();
    Get.snackbar(
      'Email',
      value
          ? 'Notifications email activées'
          : 'Notifications email désactivées',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleDarkMode(bool value) {
    darkMode.value = value;
    saveSettings();
    Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());
    Get.snackbar(
      'Thème',
      value ? 'Mode sombre activé' : 'Mode clair activé',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void toggleBiometricLogin(bool value) {
    biometricLogin.value = value;
    saveSettings();
    Get.snackbar(
      'Sécurité',
      value
          ? 'Authentification biométrique activée'
          : 'Authentification biométrique désactivée',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void changeLanguage(String newLanguage) {
    language.value = newLanguage;
    saveSettings();
    Get.snackbar(
      'Langue',
      'Langue changée en $newLanguage',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void saveSettings() {
    // Save settings to local storage
    // This would typically use SharedPreferences
    print('Settings saved');
  }

  void editProfile() {
    Get.dialog(
      AlertDialog(
        title: const Text('Modifier le profil'),
        content: const Text(
          'Cette fonctionnalité sera disponible prochainement.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void changePassword() {
    Get.dialog(
      AlertDialog(
        title: const Text('Changer le mot de passe'),
        content: const Text(
          'Cette fonctionnalité sera disponible prochainement.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void showHelp() {
    Get.dialog(
      AlertDialog(
        title: const Text('Centre d\'aide'),
        content: const Text(
          'Pour obtenir de l\'aide, contactez votre établissement scolaire.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void showAbout() {
    Get.dialog(
      AlertDialog(
        title: const Text('À propos'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Portail Élève'),
            Text('Version: 1.0.0'),
            Text('Développé pour faciliter le suivi scolaire'),
            SizedBox(height: 16),
            Text('© 2025 Tous droits réservés'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('OK')),
        ],
      ),
    );
  }

  void logout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Déconnexion',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset(
              'assets/animations/success_checkmark.json',
              height: 120,
              repeat: false,
            ),
            const SizedBox(height: 20),
            const Text(
              'Êtes-vous sûr de vouloir vous déconnecter ?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Annuler', style: TextStyle(fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              authController.logout();
              Get.snackbar(
                'Déconnexion',
                'Vous avez été déconnecté avec succès',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Déconnexion',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
        actionsAlignment: MainAxisAlignment.spaceEvenly,
      ),
    );
  }

  void clearCache() {
    Get.dialog(
      AlertDialog(
        title: const Text('Vider le cache'),
        content: const Text(
          'Cette action supprimera les données temporaires. Continuer ?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          TextButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Cache',
                'Cache vidé avec succès',
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            child: const Text('Vider'),
          ),
        ],
      ),
    );
  }
}
