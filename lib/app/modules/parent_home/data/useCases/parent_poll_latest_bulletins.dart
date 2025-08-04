import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';
import 'package:portail_eleve/app/core/services/parent_service.dart';
import 'package:portail_eleve/app/modules/parent_home/controllers/parent_home_controller.dart';

/// Service de polling pour détecter les nouveaux bulletins des enfants (compte parent).
/// Adapté du service étudiant pour les comptes parents avec plusieurs enfants.
class ParentPollLatestBulletins extends GetxService {
  final ApiClient _apiClient;
  final FlutterLocalNotificationsPlugin _notifications;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      printTime: true,
    ),
  );
  final String _channelId = 'parent_bulletins';
  final String _channelName = 'Bulletins des enfants';
  Timer? _timer;

  static const Duration _pollInterval = Duration(seconds: 15);
  static const String _lastCheckedKey = 'lastCheckedBulletinTimestamp';

  ParentPollLatestBulletins({
    required ApiClient apiClient,
    required FlutterLocalNotificationsPlugin notifications,
  }) : _apiClient = apiClient,
       _notifications = notifications;

  @override
  Future<void> onInit() async {
    super.onInit();
    await _initializeNotifications();
    _logger.i('✅ Parent bulletin polling service initialized');
  }

  @override
  void onClose() {
    stopPolling();
    super.onClose();
  }

  /// Initialise les notifications locales pour les bulletins des enfants
  Future<void> _initializeNotifications() async {
    try {
      const AndroidInitializationSettings initializationSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings initializationSettingsIOS =
          DarwinInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
          );

      const InitializationSettings initializationSettings =
          InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
          );

      await _notifications.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      _logger.i('✅ Parent bulletin notifications initialized');
    } catch (e) {
      _logger.e('❌ Error initializing parent bulletin notifications: $e');
    }
  }

  /// Gère le tap sur une notification
  void _onNotificationTapped(NotificationResponse notificationResponse) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      _logger.d(
        '🔔 Parent bulletin notification tapped with payload: $payload',
      );
      // Trigger refresh of parent home controller
      _notifyHomeScreenUpdate();
    }
  }

  /// Récupère la liste des IDs des enfants liés au compte parent
  Future<List<int>> getLinkedChildrenIds() async {
    try {
      _logger.d('🔍 Récupération des IDs enfants liés au compte parent...');

      final parentService = Get.find<ParentService>();
      final children = await parentService.getChildren();

      final childrenIds = children
          .map((child) => child.id)
          .where((id) => id != null)
          .cast<int>()
          .toList();

      _logger.i('👥 IDs enfants trouvés: $childrenIds');
      return childrenIds;
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur lors de la récupération des IDs enfants',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Récupère le timestamp de la dernière vérification pour un enfant donné
  Future<DateTime?> getLastCheckedTimestamp(int childId) async {
    try {
      final tsStr = await _secureStorage.read(
        key: '${_lastCheckedKey}_parent_$childId',
      );
      if (tsStr == null) return null;

      final ts = int.tryParse(tsStr);
      return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
    } catch (e) {
      return null;
    }
  }

  /// Sauvegarde le timestamp de la dernière vérification pour un enfant
  Future<void> setLastCheckedTimestamp(int childId, DateTime timestamp) async {
    try {
      await _secureStorage.write(
        key: '${_lastCheckedKey}_parent_$childId',
        value: timestamp.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      _logger.e('❌ Error saving last checked timestamp: $e');
    }
  }

  /// Obtient le répertoire de stockage des bulletins téléchargés
  Future<Directory> getBulletinsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final bulletinsDir = Directory('${appDir.path}/parent_bulletins');

    if (!await bulletinsDir.exists()) {
      await bulletinsDir.create(recursive: true);
    }

    return bulletinsDir;
  }

  /// Génère un nom de fichier sécurisé pour le bulletin
  Future<String> generateBulletinFileName(
    int childId,
    ReportCard reportCard,
  ) async {
    try {
      final childName = await _getChildName(childId);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sanitizedName = childName
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
          .replaceAll(' ', '_');
      return 'bulletin_${sanitizedName}_${reportCard.id}_$timestamp.pdf';
    } catch (e) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'bulletin_child_${childId}_${reportCard.id}_$timestamp.pdf';
    }
  }

  /// Récupère le nom complet de l'enfant
  Future<String> _getChildName(int childId) async {
    try {
      final parentService = Get.find<ParentService>();
      final children = await parentService.getChildren();
      final childrenUsers = await parentService.getChildrenUsers();

      final child = children.firstWhere(
        (c) => c.id == childId,
        orElse: () => throw Exception('Child not found'),
      );
      final childUser = childrenUsers.firstWhere(
        (u) => u.id == child.userModelId,
        orElse: () => throw Exception('Child user not found'),
      );

      final firstName = childUser.firstName ?? '';
      final lastName = childUser.lastName ?? '';
      final fullName = '$firstName $lastName'.trim();

      return fullName.isNotEmpty ? fullName : 'Enfant_$childId';
    } catch (e) {
      _logger.d('Could not fetch child name: $e');
      return 'Enfant_$childId';
    }
  }

  /// Télécharge le bulletin PDF de manière sécurisée
  Future<String?> downloadBulletin(int childId, ReportCard reportCard) async {
    try {
      if (reportCard.id == null) {
        _logger.w('⚠️ ID bulletin manquant pour le téléchargement');
        return null;
      }

      final bulletinsDir = await getBulletinsDirectory();
      final fileName = await generateBulletinFileName(childId, reportCard);
      final savePath = '${bulletinsDir.path}/$fileName';

      final downloadUrl = '/report-cards/${reportCard.id}/download';
      _logger.d(
        '📥 Téléchargement via API authentifiée: $downloadUrl -> $savePath',
      );

      await _apiClient.download(downloadUrl, savePath);

      final downloadedFile = File(savePath);
      if (await downloadedFile.exists() && await downloadedFile.length() > 0) {
        final fileSize = await downloadedFile.length();
        _logger.i('✅ Téléchargement réussi: $fileName (${fileSize} bytes)');
        return savePath;
      } else {
        _logger.e('❌ Fichier téléchargé invalide ou vide');
        return null;
      }
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur téléchargement bulletin',
        error: e,
        stackTrace: stackTrace,
      );
      return null;
    }
  }

  /// Effectue le polling pour détecter de nouveaux bulletins pour tous les enfants
  Future<void> poll() async {
    try {
      _logger.i('🔄 Début du polling des bulletins enfants...');
      final childrenIds = await getLinkedChildrenIds();

      if (childrenIds.isEmpty) {
        _logger.w('⚠️ Aucun enfant trouvé pour le polling');
        return;
      }

      for (final childId in childrenIds) {
        await _pollForChild(childId);
      }

      _logger.i('✅ Polling terminé pour ${childrenIds.length} enfant(s)');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur générale lors du polling',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Traite le polling pour un enfant spécifique
  Future<void> _pollForChild(int childId) async {
    try {
      _logger.d('🎓 Polling pour l\'enfant ID: $childId');

      final lastChecked = await getLastCheckedTimestamp(childId);
      final queryParams = <String, dynamic>{};

      // Always set 'since' to 2 months before today
      final twoMonthsAgo = DateTime.now().subtract(const Duration(days: 60));
      queryParams['since'] = twoMonthsAgo.toIso8601String();
      _logger.d('📅 Recherche depuis: ${twoMonthsAgo.toIso8601String()}');

      final endpoint = '/students/$childId/bulletins/latest';
      _logger.d('🌐 Appel API: $endpoint avec params: $queryParams');

      final response = await _apiClient.get(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      _logger.i('📡 Réponse API [${response.statusCode}]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        await _processApiResponse(childId, response.data);
      } else if (response.statusCode == 404) {
        _logger.i('📭 Aucun bulletin trouvé pour l\'enfant $childId');
      } else {
        _logger.w(
          '⚠️ Réponse API inattendue [${response.statusCode}]: ${response.data}',
        );
      }

      await setLastCheckedTimestamp(childId, DateTime.now());
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur polling enfant $childId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Traite la réponse de l'API et extrait les bulletins
  Future<void> _processApiResponse(int childId, dynamic responseData) async {
    try {
      _logger.d('🔍 Traitement de la réponse API...');
      ReportCard? latestReportCard;

      if (responseData is Map<String, dynamic>) {
        _logger.d('📋 Réponse de type Map détectée');

        if (responseData['report_card'] != null) {
          _logger.d('📄 Bulletin trouvé dans report_card wrapper');
          latestReportCard = ReportCard.fromJson(responseData['report_card']);
        } else if (responseData.containsKey('report_card') &&
            responseData['report_card'] == null) {
          _logger.i(
            '📭 Backend confirme: aucun bulletin disponible pour l\'enfant $childId',
          );
          return;
        } else if (responseData.containsKey('id')) {
          _logger.d('📄 Bulletin direct détecté');
          latestReportCard = ReportCard.fromJson(responseData);
        }
      } else if (responseData is List && responseData.isNotEmpty) {
        _logger.d(
          '📋 Réponse de type Array détectée avec ${responseData.length} élément(s)',
        );

        final reportCards = responseData
            .map((json) => ReportCard.fromJson(json))
            .toList();

        reportCards.sort((a, b) {
          if (a.createdAt == null || b.createdAt == null) return 0;
          return b.createdAt!.compareTo(a.createdAt!);
        });

        latestReportCard = reportCards.first;
        _logger.d(
          '📄 Bulletin le plus récent sélectionné: ID ${latestReportCard.id}',
        );
      }

      if (latestReportCard != null && latestReportCard.id != null) {
        _logger.i(
          '📋 Bulletin trouvé: ID ${latestReportCard.id}, Note: ${latestReportCard.averageGrade}, Mention: ${latestReportCard.honors}',
        );

        if (await _isNewBulletin(childId, latestReportCard)) {
          _logger.i('🆕 Nouveau bulletin détecté, traitement...');

          final downloadPath = await downloadBulletin(
            childId,
            latestReportCard,
          );
          await showBulletinNotification(
            childId,
            latestReportCard,
            downloadPath,
          );
          await _storeLastBulletinId(childId, latestReportCard.id!);
          await _notifyHomeScreenUpdate();

          _logger.i('✅ Nouveau bulletin traité avec succès');
        } else {
          _logger.d('📋 Bulletin déjà connu, pas de notification');
        }
      } else {
        _logger.d('📭 Aucun bulletin valide trouvé dans la réponse');
      }
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur traitement réponse API',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Notifie l'écran d'accueil parent qu'il doit rafraîchir les données
  Future<void> _notifyHomeScreenUpdate() async {
    try {
      if (Get.isRegistered<ParentHomeController>()) {
        final controller = Get.find<ParentHomeController>();
        await controller.loadParentDashboardData();
        _logger.d('🔄 Interface parent notifiée pour rafraîchissement');
      }
    } catch (e) {
      _logger.d('ℹ️ Notification interface échouée (non critique): $e');
    }
  }

  /// Vérifie si le bulletin est nouveau (pas encore notifié)
  Future<bool> _isNewBulletin(int childId, ReportCard reportCard) async {
    try {
      final lastBulletinIdStr = await _secureStorage.read(
        key: 'lastBulletinId_parent_$childId',
      );

      _logger.d(
        '🔍 Vérification nouveau bulletin - ID actuel: ${reportCard.id}, Dernier ID stocké: $lastBulletinIdStr',
      );

      if (lastBulletinIdStr == null) {
        _logger.d('✅ Aucun bulletin précédent stocké - marqué comme nouveau');
        return true;
      }

      final lastBulletinId = int.tryParse(lastBulletinIdStr);
      final isNew = lastBulletinId != reportCard.id;

      _logger.d('🔍 Comparaison: $lastBulletinId != ${reportCard.id} = $isNew');

      return isNew;
    } catch (e) {
      _logger.e('❌ Erreur vérification nouveau bulletin', error: e);
      return true;
    }
  }

  /// Stocke l'ID du dernier bulletin notifié
  Future<void> _storeLastBulletinId(int childId, int bulletinId) async {
    try {
      await _secureStorage.write(
        key: 'lastBulletinId_parent_$childId',
        value: bulletinId.toString(),
      );
    } catch (e) {
      _logger.e('❌ Error storing last bulletin ID: $e');
    }
  }

  /// Affiche une notification pour un nouveau bulletin d'enfant
  Future<void> showBulletinNotification(
    int childId,
    ReportCard reportCard, [
    String? downloadPath,
  ]) async {
    try {
      final childName = await _getChildName(childId);
      final title = 'Nouveau bulletin disponible';

      String body;
      if (downloadPath != null) {
        body =
            'Le bulletin de $childName a été téléchargé (Note: ${reportCard.averageGrade ?? 'N/A'}).';
      } else {
        body =
            'Le bulletin de $childName est disponible (Note: ${reportCard.averageGrade ?? 'N/A'}).';
      }

      _logger.i('🔔 Affichage notification parent: $title - $body');

      await _notifications.show(
        reportCard.id!,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            showWhen: true,
            when: DateTime.now().millisecondsSinceEpoch,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: 'child_$childId',
      );

      _logger.i('✅ Notification parent envoyée avec succès');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur affichage notification parent',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Démarre le polling périodique
  void startPolling() {
    stopPolling();
    _logger.i(
      '🚀 Démarrage du polling automatique parent (intervalle: ${_pollInterval.inMinutes} min)',
    );

    poll(); // Premier polling immédiat

    _timer = Timer.periodic(_pollInterval, (_) {
      _logger.d('⏰ Déclenchement polling périodique parent');
      poll();
    });
  }

  /// Arrête le polling
  void stopPolling() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _logger.i('⏹️ Polling parent arrêté');
    }
  }

  /// Effectue un polling immédiat
  Future<void> pollNow() async {
    _logger.i('🔄 Polling manuel parent déclenché');
    await poll();
  }

  /// Active le mode debug avec polling fréquent (30 secondes)
  void enableDebugMode() {
    stopPolling();
    _logger.w('🐛 Mode DEBUG parent activé - Polling toutes les 30 secondes');

    poll();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _logger.d('🐛 DEBUG: Polling parent fréquent');
      poll();
    });
  }

  /// Force un nouveau polling et traite tous les bulletins comme nouveaux
  Future<void> forceRefreshBulletins() async {
    try {
      _logger.i('🔄 Forçage du rafraîchissement des bulletins parent...');
      final childrenIds = await getLinkedChildrenIds();

      for (final childId in childrenIds) {
        await _secureStorage.delete(key: 'lastBulletinId_parent_$childId');
      }

      await poll();
      _logger.i('✅ Rafraîchissement forcé parent terminé');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur lors du rafraîchissement forcé parent',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
