import 'package:get/get.dart';

class HistoryController extends GetxController {
  final RxList<Map<String, dynamic>> bulletinHistory =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadBulletinHistory();
  }

  Future<void> loadBulletinHistory() async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      bulletinHistory.value = [
        {
          'id': 1,
          'title': 'Bulletin 1er Trimestre',
          'periode': '2024-2025',
          'status': 'Consulté',
          'moyenne': '15.8',
          'date': '15/01/2025',
          'trimestre': 1,
          'downloadUrl': 'https://example.com/bulletin1.pdf',
          'subjects': [
            {'name': 'Mathématiques', 'grade': '16.5'},
            {'name': 'Physique-Chimie', 'grade': '15.2'},
            {'name': 'Français', 'grade': '14.8'},
          ],
        },
        {
          'id': 2,
          'title': 'Bulletin 2ème Trimestre',
          'periode': '2024-2025',
          'status': 'Consulté',
          'moyenne': '16.2',
          'date': '25/04/2025',
          'trimestre': 2,
          'downloadUrl': 'https://example.com/bulletin2.pdf',
          'subjects': [
            {'name': 'Mathématiques', 'grade': '17.0'},
            {'name': 'Physique-Chimie', 'grade': '16.5'},
            {'name': 'Français', 'grade': '15.1'},
          ],
        },
        {
          'id': 3,
          'title': 'Bulletin 3ème Trimestre',
          'periode': '2024-2025',
          'status': 'Nouveau',
          'moyenne': '15.5',
          'date': '10/07/2025',
          'trimestre': 3,
          'downloadUrl': 'https://example.com/bulletin3.pdf',
          'subjects': [
            {'name': 'Mathématiques', 'grade': '15.8'},
            {'name': 'Physique-Chimie', 'grade': '15.0'},
            {'name': 'Français', 'grade': '15.8'},
          ],
        },
        {
          'id': 4,
          'title': 'Bulletin 1er Trimestre',
          'periode': '2023-2024',
          'status': 'Consulté',
          'moyenne': '14.9',
          'date': '20/01/2024',
          'trimestre': 1,
          'downloadUrl': 'https://example.com/bulletin4.pdf',
          'subjects': [
            {'name': 'Mathématiques', 'grade': '15.2'},
            {'name': 'Physique-Chimie', 'grade': '14.5'},
            {'name': 'Français', 'grade': '15.0'},
          ],
        },
        {
          'id': 5,
          'title': 'Bulletin 2ème Trimestre',
          'periode': '2023-2024',
          'status': 'Consulté',
          'moyenne': '15.1',
          'date': '15/04/2024',
          'trimestre': 2,
          'downloadUrl': 'https://example.com/bulletin5.pdf',
          'subjects': [
            {'name': 'Mathématiques', 'grade': '15.5'},
            {'name': 'Physique-Chimie', 'grade': '14.8'},
            {'name': 'Français', 'grade': '15.0'},
          ],
        },
      ];
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de charger l\'historique');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> get filteredBulletins {
    if (selectedFilter.value == 'all') {
      return bulletinHistory;
    }
    return bulletinHistory.where((bulletin) {
      switch (selectedFilter.value) {
        case 'current':
          return bulletin['periode'] == '2024-2025';
        case 'previous':
          return bulletin['periode'] == '2023-2024';
        case 'unread':
          return bulletin['status'] == 'Nouveau';
        default:
          return true;
      }
    }).toList();
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
  }

  void viewBulletin(int bulletinId) {
    final bulletin = bulletinHistory.firstWhere((b) => b['id'] == bulletinId);
    Get.snackbar(
      'Bulletin',
      'Ouverture du ${bulletin['title']}',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void downloadBulletin(int bulletinId) {
    final bulletin = bulletinHistory.firstWhere((b) => b['id'] == bulletinId);
    Get.snackbar(
      'Téléchargement',
      'Téléchargement du ${bulletin['title']} en cours...',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> refreshHistory() async {
    await loadBulletinHistory();
  }
}
