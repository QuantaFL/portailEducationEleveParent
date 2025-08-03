import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';

import 'poll_latest_bulletins.dart';

/// Service de debug pour tester le système de polling des bulletins.
/// Utile pour déboguer et comprendre les réponses du backend.
class BulletinDebugService {
  static PollLatestBulletins? _pollService;

  /// Initialise le service de polling avec logging complet.
  static void initialize() {
    try {
      final apiClient = Get.find<ApiClient>();
      final notifications = Get.find<FlutterLocalNotificationsPlugin>();

      _pollService = PollLatestBulletins(
        apiClient: apiClient,
        notifications: notifications,
      );

      print('✅ BulletinDebugService initialisé avec succès');
    } catch (e) {
      print('❌ Erreur initialisation BulletinDebugService: $e');
    }
  }

  /// Effectue un test de polling immédiat avec logs détaillés.
  static Future<void> testPollingNow() async {
    if (_pollService == null) {
      print('⚠️ Service non initialisé. Appelez initialize() d\'abord.');
      return;
    }

    print('🔄 DÉBUT TEST POLLING - ${DateTime.now()}');
    print('=' * 50);

    await _pollService!.pollNow();

    print('=' * 50);
    print('✅ FIN TEST POLLING - ${DateTime.now()}');
  }

  /// Active le mode debug avec polling fréquent (30 secondes).
  static void enableDebugMode() {
    if (_pollService == null) {
      print('⚠️ Service non initialisé. Appelez initialize() d\'abord.');
      return;
    }

    _pollService!.enableDebugMode();
    print('🐛 Mode debug activé - Polling toutes les 30 secondes');
  }

  /// Démarre le polling normal (2 minutes).
  static void startNormalPolling() {
    if (_pollService == null) {
      print('⚠️ Service non initialisé. Appelez initialize() d\'abord.');
      return;
    }

    _pollService!.startPolling();
    print('🚀 Polling normal démarré - Toutes les 2 minutes');
  }

  /// Arrête tout polling.
  static void stopPolling() {
    if (_pollService == null) {
      print('⚠️ Service non initialisé.');
      return;
    }

    _pollService!.stopPolling();
    print('⏹️ Polling arrêté');
  }

  /// Affiche l'état actuel du service.
  static Future<void> showStatus() async {
    if (_pollService == null) {
      print('❌ Service non initialisé');
      return;
    }

    print('📊 ÉTAT DU SERVICE BULLETIN');
    print('=' * 30);

    final studentIds = await _pollService!.getLinkedStudentIds();
    print('👥 Étudiants liés: $studentIds');

    for (final studentId in studentIds) {
      final lastChecked = await _pollService!.getLastCheckedTimestamp(
        studentId,
      );
      print('📅 Dernier check étudiant $studentId: ${lastChecked ?? "Jamais"}');
    }

    final downloadedFiles = await _pollService!.getDownloadedBulletins();
    print('📁 Bulletins téléchargés: ${downloadedFiles.length}');

    print('=' * 30);
  }

  /// Nettoie les données de test (timestamps, etc.).
  static Future<void> clearTestData() async {
    if (_pollService == null) {
      print('⚠️ Service non initialisé.');
      return;
    }

    final studentIds = await _pollService!.getLinkedStudentIds();

    for (final studentId in studentIds) {
      await _pollService!.secureStorage.delete(
        key: 'lastCheckedBulletinTimestamp_$studentId',
      );
      await _pollService!.secureStorage.delete(
        key: 'lastBulletinId_$studentId',
      );
    }

    print(
      '🗑️ Données de test effacées - Le prochain polling sera comme un premier run',
    );
  }
}
