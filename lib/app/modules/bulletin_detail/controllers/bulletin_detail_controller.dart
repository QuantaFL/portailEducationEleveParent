import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class BulletinDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isDownloading = false.obs;
  final RxMap<String, dynamic> bulletinData = <String, dynamic>{}.obs;
  final RxList<Map<String, dynamic>> subjects = <Map<String, dynamic>>[].obs;
  final RxString pdfUrl = ''.obs;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  String? bulletinId;

  @override
  void onInit() {
    super.onInit();
    bulletinId = Get.parameters['id'];
    if (bulletinId != null) {
      loadBulletinDetails();
    }
  }

  Future<void> loadBulletinDetails() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock bulletin data
      bulletinData.value = {
        'id': bulletinId,
        'title': 'Bulletin du 1er Trimestre',
        'periode': '2024-2025',
        'classe': 'Terminale S',
        'etablissement': 'Lycée Victor Hugo',
        'moyenne_generale': 15.3,
        'moyenne_classe': 13.8,
        'rang': 6,
        'total_eleves': 32,
        'appreciation_generale':
            'Très bon trimestre. Élève sérieux et assidu. Continuez dans cette voie.',
        'date_conseil': '15/01/2025',
        'date_edition': '18/01/2025',
      };

      // Mock subjects data
      subjects.value = [
        {
          'nom': 'Mathématiques',
          'moyenne': 16.5,
          'coefficient': 7,
          'moyenne_classe': 14.2,
          'rang': 4,
          'appreciation': 'Excellent travail. Élève très investi.',
          'professeur': 'M. Dupont',
          'notes': [
            {
              'type': 'Devoir surveillé',
              'note': 17,
              'sur': 20,
              'date': '10/11/2024',
            },
            {
              'type': 'Interrogation',
              'note': 15,
              'sur': 20,
              'date': '25/11/2024',
            },
            {
              'type': 'Devoir maison',
              'note': 18,
              'sur': 20,
              'date': '05/12/2024',
            },
          ],
        },
        {
          'nom': 'Physique-Chimie',
          'moyenne': 15.2,
          'coefficient': 6,
          'moyenne_classe': 13.5,
          'rang': 5,
          'appreciation':
              'Bon niveau. Quelques difficultés en chimie à travailler.',
          'professeur': 'Mme Martin',
          'notes': [
            {'type': 'TP', 'note': 16, 'sur': 20, 'date': '08/11/2024'},
            {'type': 'Contrôle', 'note': 14, 'sur': 20, 'date': '22/11/2024'},
            {
              'type': 'Devoir surveillé',
              'note': 15.5,
              'sur': 20,
              'date': '06/12/2024',
            },
          ],
        },
        {
          'nom': 'Français',
          'moyenne': 14.8,
          'coefficient': 4,
          'moyenne_classe': 13.0,
          'rang': 8,
          'appreciation':
              'Expression écrite à améliorer. Bonne participation orale.',
          'professeur': 'Mme Rousseau',
          'notes': [
            {
              'type': 'Dissertation',
              'note': 13,
              'sur': 20,
              'date': '12/11/2024',
            },
            {'type': 'Oral', 'note': 16, 'sur': 20, 'date': '28/11/2024'},
            {
              'type': 'Commentaire',
              'note': 15,
              'sur': 20,
              'date': '10/12/2024',
            },
          ],
        },
        {
          'nom': 'Histoire-Géographie',
          'moyenne': 15.5,
          'coefficient': 3,
          'moyenne_classe': 14.1,
          'rang': 7,
          'appreciation': 'Bon travail. Connaissances solides.',
          'professeur': 'M. Bernard',
          'notes': [
            {'type': 'Contrôle', 'note': 15, 'sur': 20, 'date': '15/11/2024'},
            {'type': 'Exposé', 'note': 17, 'sur': 20, 'date': '29/11/2024'},
            {
              'type': 'Devoir surveillé',
              'note': 14.5,
              'sur': 20,
              'date': '12/12/2024',
            },
          ],
        },
      ];

      pdfUrl.value = 'https://example.com/bulletin.pdf';
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Impossible de charger le bulletin',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadBulletin() async {
    try {
      isDownloading.value = true;

      // Simulate download
      await Future.delayed(const Duration(seconds: 2));

      Get.snackbar(
        'Téléchargement terminé',
        'Le bulletin a été téléchargé avec succès',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Erreur de téléchargement',
        'Impossible de télécharger le bulletin',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isDownloading.value = false;
    }
  }

  Future<void> shareBulletin() async {
    Get.snackbar(
      'Partage',
      'Fonctionnalité de partage bientôt disponible',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void viewPDF() {
    if (pdfUrl.value.isNotEmpty) {
      Get.toNamed('/pdf-viewer', parameters: {'url': pdfUrl.value});
    }
  }
}
