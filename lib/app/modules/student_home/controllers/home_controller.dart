import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/next_class.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/core/data/repositories/bulletin_repository.dart';
import 'package:portail_eleve/app/core/data/repositories/student_repository.dart';
import 'package:portail_eleve/app/modules/student_home/data/useCases/bulletin_debug_service.dart';
import 'package:portail_eleve/app/modules/student_home/data/useCases/poll_latest_bulletins.dart';
import 'package:portail_eleve/app/routes/app_pages.dart';

class HomeController extends GetxController {
  final BulletinRepository bulletinRepository;
  final StudentRepository studentRepository;
  late final PollLatestBulletins _pollService;

  var currentIndex = 0.obs;
  var isLoading = false.obs;
  var student = Rx<Student?>(null);
  var recentBulletins = <ReportCard>[].obs;
  var allBulletins = <ReportCard>[].obs;
  final hasNewBulletin = false.obs;

  HomeController({
    required this.bulletinRepository,
    required this.studentRepository,
  });

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    _initializeBulletinPolling();
  }

  @override
  void onReady() {
    super.onReady();
    // Démarre le polling une fois que la vue est prête
    _startBulletinPolling();
  }

  @override
  void onClose() {
    _pollService.dispose();
    super.onClose();
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

          // Load bulletins after student data is loaded
          await _loadBulletins(int.parse(studentId));
        } catch (e) {
          Logger logger = Logger();
          logger.e('Failed to fetch student details from backend: $e');
          await studentRepository.getStudentFromHive(int.parse(studentId));
          student.value = studentRepository.student;

          // Still try to load bulletins even if student details failed
          try {
            await _loadBulletins(int.parse(studentId));
          } catch (bulletinError) {
            logger.e('Failed to load bulletins: $bulletinError');
          }
        }
      }
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

  /// Loads bulletins for the specified student
  Future<void> _loadBulletins(int studentId) async {
    try {
      final Logger logger = Logger();
      logger.d('🔍 Chargement des bulletins pour l\'étudiant $studentId...');

      final bulletins = await bulletinRepository.getBulletins(studentId);
      allBulletins.value = bulletins;

      // Sort by creation date (most recent first) and take the latest ones
      final sortedBulletins = List<ReportCard>.from(bulletins);
      sortedBulletins.sort((a, b) {
        if (a.createdAt == null || b.createdAt == null) return 0;
        return b.createdAt!.compareTo(a.createdAt!);
      });

      // Show the 3 most recent bulletins
      recentBulletins.value = sortedBulletins.take(3).toList();

      logger.i(
        '✅ Chargé ${bulletins.length} bulletins (${recentBulletins.length} récents)',
      );

      if (bulletins.isNotEmpty) {
        logger.d(
          '📋 Bulletins récents: ${recentBulletins.map((b) => 'ID ${b.id} (${b.averageGrade})').join(', ')}',
        );
      }
    } catch (e) {
      final Logger logger = Logger();
      logger.e('❌ Erreur lors du chargement des bulletins: $e');
      // Don't show error to user for bulletins, just log it
    }
  }

  /// Downloads and opens a bulletin PDF
  Future<void> downloadBulletin(int bulletinId) async {
    try {
      isLoading.value = true;

      final bulletin = [...allBulletins, ...recentBulletins].firstWhere(
        (b) => b.id == bulletinId,
        orElse: () => throw Exception('Bulletin non trouvé'),
      );

      final studentName = student.value?.userModel?.firstName ?? 'Etudiant';
      final studentId = int.parse(
        await const FlutterSecureStorage().read(key: 'studentId') ?? '0',
      );

      if (studentId == 0) {
        throw Exception('ID étudiant non trouvé');
      }

      Get.snackbar(
        'Téléchargement',
        'Téléchargement du bulletin en cours...',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      final downloadPath = await _pollService.downloadBulletin(
        studentId,
        bulletin,
      );

      if (downloadPath != null) {
        // Success - show completion and open file
        Get.snackbar(
          'Téléchargement terminé',
          'Bulletin de $studentName téléchargé avec succès',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Open the downloaded PDF
        await _openPdfFile(downloadPath);
      } else {
        throw Exception('Échec du téléchargement');
      }
    } catch (e) {
      Logger().e('Erreur téléchargement bulletin: $e');
      Get.snackbar(
        'Erreur',
        'Impossible de télécharger le bulletin: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Opens a PDF file using the default system application
  Future<void> _openPdfFile(String filePath) async {
    try {
      Logger().d('🔍 Tentative d\'ouverture du fichier: $filePath');

      final result = await OpenFile.open(filePath);

      if (result.type == ResultType.done) {
        Logger().i('✅ Fichier PDF ouvert avec succès');
        Get.snackbar(
          'Fichier ouvert',
          'Le bulletin a été ouvert dans votre lecteur PDF',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Logger().w('⚠️ Erreur ouverture fichier: ${result.message}');
        _showFileLocationFallback(filePath);
      }
    } catch (e) {
      Logger().e('❌ Erreur ouverture fichier: $e');
      _showFileLocationFallback(filePath);
    }
  }

  /// Shows fallback message when PDF can't be opened automatically
  void _showFileLocationFallback(String filePath) {
    final fileName = filePath.split('/').last;

    Get.dialog(
      AlertDialog(
        title: const Text(
          '📁 Fichier téléchargé',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Le bulletin a été téléchargé avec succès !',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nom du fichier:',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    fileName,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Vous pouvez le retrouver dans le gestionnaire de fichiers de votre appareil.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Fermer')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Could add future functionality to show file location or retry opening
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF6366F1),
              foregroundColor: Colors.white,
            ),
            child: const Text('Compris'),
          ),
        ],
      ),
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

  /// Initialise le service de polling des bulletins.
  void _initializeBulletinPolling() {
    try {
      final apiClient = Get.find<ApiClient>();

      // Try to get notifications plugin, create one if not found
      FlutterLocalNotificationsPlugin notifications;
      try {
        notifications = Get.find<FlutterLocalNotificationsPlugin>();
      } catch (e) {
        print(
          '⚠️ FlutterLocalNotificationsPlugin not found in GetX, creating new instance...',
        );
        notifications = FlutterLocalNotificationsPlugin();

        // Initialize the notifications plugin
        const AndroidInitializationSettings initializationSettingsAndroid =
            AndroidInitializationSettings('@mipmap/ic_launcher');

        const InitializationSettings initializationSettings =
            InitializationSettings(android: initializationSettingsAndroid);

        notifications.initialize(initializationSettings);

        // Register it in GetX for future use
        Get.put(notifications);
      }

      _pollService = PollLatestBulletins(
        apiClient: apiClient,
        notifications: notifications,
      );

      print('✅ Polling des bulletins initialisé pour l\'étudiant');
    } catch (e) {
      print('❌ Erreur initialisation polling étudiant: $e');
      // Don't set _pollService if initialization fails
    }
  }

  /// Démarre le polling automatique des bulletins.
  void _startBulletinPolling() {
    // Only start polling if the service was successfully initialized
    if (_pollService != null) {
      _pollService.startPolling();
      print('🚀 Polling automatique des bulletins démarré pour l\'étudiant');
    } else {
      print('⚠️ Cannot start polling - service not initialized');
    }
  }

  /// Force une vérification immédiate des nouveaux bulletins.
  Future<void> checkForNewBulletins() async {
    if (_pollService == null) {
      print('⚠️ Polling service not available');
      return;
    }

    isLoading.value = true;
    try {
      await _pollService.pollNow();
      print('🔄 Vérification manuelle des bulletins effectuée');
    } catch (e) {
      print('❌ Erreur lors de la vérification manuelle: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Active le mode debug pour tester le polling (développement uniquement).
  void enableDebugMode() {
    if (_pollService == null) {
      print('⚠️ Polling service not available');
      return;
    }

    BulletinDebugService.initialize();
    _pollService.enableDebugMode();
    print('🐛 Mode debug activé - Polling fréquent');
  }

  /// Teste le polling immédiatement avec logs détaillés.
  Future<void> testPolling() async {
    if (_pollService == null) {
      print('⚠️ Polling service not available - trying to reinitialize...');
      _initializeBulletinPolling();
      if (_pollService == null) {
        print('❌ Failed to initialize polling service');
        return;
      }
    }

    BulletinDebugService.initialize();
    await BulletinDebugService.testPollingNow();
  }

  /// Affiche le statut du service de polling.
  Future<void> showPollingStatus() async {
    if (_pollService == null) {
      print('❌ Polling service not initialized');
      return;
    }

    BulletinDebugService.initialize();
    await BulletinDebugService.showStatus();
  }

  /// Nettoie les données de test du polling.
  Future<void> clearPollingData() async {
    if (_pollService == null) {
      print('⚠️ Polling service not available');
      return;
    }

    BulletinDebugService.initialize();
    await BulletinDebugService.clearTestData();
    print('🗑️ Données de polling nettoyées');
  }

  /// Récupère les bulletins téléchargés localement.
  Future<void> getDownloadedBulletins() async {
    if (_pollService == null) {
      print('⚠️ Polling service not available');
      return;
    }

    try {
      final bulletins = await _pollService.getDownloadedBulletins();
      print('📁 ${bulletins.length} bulletin(s) téléchargé(s) localement');
    } catch (e) {
      print('❌ Erreur récupération bulletins: $e');
    }
  }

  /// Nettoie les anciens bulletins téléchargés.
  Future<void> cleanupOldBulletins() async {
    if (_pollService == null) {
      print('⚠️ Polling service not available');
      return;
    }

    try {
      await _pollService.cleanupOldBulletins();
      print('🗑️ Anciens bulletins nettoyés');
    } catch (e) {
      print('❌ Erreur nettoyage bulletins: $e');
    }
  }

  /// Refreshes bulletin data
  Future<void> refreshBulletins() async {
    const storage = FlutterSecureStorage();
    final studentId = await storage.read(key: 'studentId');
    if (studentId != null) {
      await _loadBulletins(int.parse(studentId));
    }
  }
}
