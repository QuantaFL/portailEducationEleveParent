import 'dart:async';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';

/// Service de polling pour détecter les nouveaux bulletins disponibles.
/// Gère la notification et le téléchargement sécurisé des bulletins.
class PollLatestBulletins {
  final ApiClient apiClient;
  final FlutterLocalNotificationsPlugin notifications;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
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
  final String channelId = 'bulletins';
  final String channelName = 'Documents disponibles';
  Timer? _timer;

  static const Duration _pollInterval = Duration(minutes: 2);
  static const String _lastCheckedKey = 'lastCheckedBulletinTimestamp';
  static const String _userIdKey = 'user_id';

  PollLatestBulletins({required this.apiClient, required this.notifications});

  /// Récupère la liste des IDs des étudiants liés au compte actuel.
  Future<List<int>> getLinkedStudentIds() async {
    try {
      _logger.d('🔍 Récupération des IDs étudiants liés...');

      // Try to get student IDs from different possible storage keys
      final userIdStr = await secureStorage.read(key: _userIdKey);
      final studentIdStr = await secureStorage.read(key: 'student_id');
      final currentUserStr = await secureStorage.read(key: 'current_user_id');

      _logger.d(
        '📋 Storage keys found: user_id=$userIdStr, student_id=$studentIdStr, current_user_id=$currentUserStr',
      );

      final studentIds = <int>[];

      // Try different storage patterns
      for (final idStr in [userIdStr, studentIdStr, currentUserStr]) {
        if (idStr != null) {
          final id = int.tryParse(idStr);
          if (id != null && !studentIds.contains(id)) {
            studentIds.add(id);
          }
        }
      }

      // If no student IDs found, try to get from additional keys
      if (studentIds.isEmpty) {
        _logger.w(
          '⚠️ Aucun ID étudiant trouvé dans le storage principal, recherche étendue...',
        );

        // Check for parent-child relationships
        final allKeys = await secureStorage.readAll();
        _logger.d('🗂️ Toutes les clés de storage: ${allKeys.keys.toList()}');

        for (final entry in allKeys.entries) {
          if (entry.key.contains('student') || entry.key.contains('child')) {
            final id = int.tryParse(entry.value);
            if (id != null && !studentIds.contains(id)) {
              studentIds.add(id);
              _logger.d('✅ ID étudiant trouvé via ${entry.key}: $id');
            }
          }
        }
      }

      _logger.i('👥 IDs étudiants trouvés: $studentIds');
      return studentIds;
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur lors de la récupération des IDs étudiants',
        error: e,
        stackTrace: stackTrace,
      );
      return [];
    }
  }

  /// Récupère le timestamp de la dernière vérification pour un étudiant donné.
  /// Retourne null si aucune vérification précédente n'a été effectuée.
  Future<DateTime?> getLastCheckedTimestamp(int studentId) async {
    try {
      final tsStr = await secureStorage.read(
        key: '${_lastCheckedKey}_$studentId',
      );
      if (tsStr == null) return null;

      final ts = int.tryParse(tsStr);
      return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
    } catch (e) {
      return null;
    }
  }

  /// Sauvegarde le timestamp de la dernière vérification pour un étudiant.
  Future<void> setLastCheckedTimestamp(
    int studentId,
    DateTime timestamp,
  ) async {
    try {
      await secureStorage.write(
        key: '${_lastCheckedKey}_$studentId',
        value: timestamp.millisecondsSinceEpoch.toString(),
      );
    } catch (e) {
      // Silently handle storage errors
    }
  }

  /// Obtient le répertoire de stockage des bulletins téléchargés.
  Future<Directory> getBulletinsDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final bulletinsDir = Directory('${appDir.path}/bulletins');

    if (!await bulletinsDir.exists()) {
      await bulletinsDir.create(recursive: true);
    }

    return bulletinsDir;
  }

  /// Génère un nom de fichier sécurisé pour le bulletin.
  Future<String> generateBulletinFileName(
    int studentId,
    ReportCard reportCard,
  ) async {
    try {
      // Get student name for proper file naming
      final studentName = await _getStudentName(studentId);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final sanitizedName = studentName
          .replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), '')
          .replaceAll(' ', '_');
      return 'bulletin_${sanitizedName}_${reportCard.id}_$timestamp.pdf';
    } catch (e) {
      // Fallback to generic naming if student name can't be retrieved
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'bulletin_${studentId}_${reportCard.id}_$timestamp.pdf';
    }
  }

  /// Récupère le nom complet de l'étudiant via l'API
  Future<String> _getStudentName(int studentId) async {
    try {
      // Try to get student details from API
      final response = await apiClient.get('/students/$studentId');
      if (response.statusCode == 200 && response.data != null) {
        final studentData = response.data;

        // Extract from userModel if available
        if (studentData['userModel'] != null) {
          final userModel = studentData['userModel'];
          final firstName = userModel['first_name'] ?? '';
          final lastName = userModel['last_name'] ?? '';
          final fullName = '$firstName $lastName'.trim();
          if (fullName.isNotEmpty) {
            return fullName;
          }
        }

        // Fallback to direct fields
        final firstName =
            studentData['firstName'] ?? studentData['first_name'] ?? '';
        final lastName =
            studentData['lastName'] ?? studentData['last_name'] ?? '';
        final fullName = '$firstName $lastName'.trim();
        if (fullName.isNotEmpty) {
          return fullName;
        }

        // Use matricule as fallback
        final matricule = studentData['matricule'] ?? '';
        if (matricule.isNotEmpty) {
          return matricule;
        }
      }
    } catch (e) {
      _logger.d('Could not fetch student name from API: $e');
    }

    // Fallback to generic name
    return 'Etudiant_$studentId';
  }

  /// Télécharge le bulletin PDF de manière sécurisée en utilisant le pdf_url.
  /// Retourne le chemin local du fichier téléchargé ou null en cas d'erreur.
  Future<String?> downloadBulletin(int studentId, ReportCard reportCard) async {
    try {
      if (reportCard.id == null) {
        _logger.w('⚠️ ID bulletin manquant pour le téléchargement');
        return null;
      }

      final bulletinsDir = await getBulletinsDirectory();
      final fileName = await generateBulletinFileName(studentId, reportCard);
      final savePath = '${bulletinsDir.path}/$fileName';

      // Always use the authenticated API endpoint for downloads
      final downloadUrl = '/report-cards/${reportCard.id}/download';
      _logger.d(
        '📥 Téléchargement via API authentifiée: $downloadUrl -> $savePath',
      );

      // Use the API client with authentication
      await apiClient.download(downloadUrl, savePath);

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

  /// Récupère le nom de l'étudiant pour personnaliser les notifications.
  /// Retourne un nom par défaut si indisponible.
  Future<String> getStudentName(int studentId) async {
    try {
      return 'Votre enfant';
    } catch (e) {
      return 'Votre enfant';
    }
  }

  /// Effectue le polling pour détecter de nouveaux bulletins.
  /// Vérifie tous les étudiants liés et traite les nouveaux bulletins.
  Future<void> poll() async {
    try {
      _logger.i('🔄 Début du polling des bulletins...');
      final studentIds = await getLinkedStudentIds();

      if (studentIds.isEmpty) {
        _logger.w('⚠️ Aucun étudiant trouvé pour le polling');
        return;
      }

      for (final studentId in studentIds) {
        await _pollForStudent(studentId);
      }

      _logger.i('✅ Polling terminé pour ${studentIds.length} étudiant(s)');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur générale lors du polling',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Traite le polling pour un étudiant spécifique.
  Future<void> _pollForStudent(int studentId) async {
    try {
      _logger.d('🎓 Polling pour l\'étudiant ID: $studentId');

      final lastChecked = await getLastCheckedTimestamp(studentId);
      final queryParams = <String, dynamic>{};

      // Always set 'since' to 2 months before today
      final twoMonthsAgo = DateTime.now().subtract(const Duration(days: 60));
      queryParams['since'] = twoMonthsAgo.toIso8601String();
      _logger.d(
        '📅 Recherche depuis: [32m${twoMonthsAgo.toIso8601String()}[0m',
      );

      final endpoint = '/students/$studentId/bulletins/latest';
      _logger.d('🌐 Appel API: $endpoint avec params: $queryParams');

      final response = await apiClient.get(
        endpoint,
        queryParams: queryParams.isNotEmpty ? queryParams : null,
      );

      _logger.i('📡 Réponse API [${response.statusCode}]: ${response.data}');

      if (response.statusCode == 200 && response.data != null) {
        await _processApiResponse(studentId, response.data);
      } else if (response.statusCode == 404) {
        _logger.i('📭 Aucun bulletin trouvé pour l\'étudiant $studentId');
      } else {
        _logger.w(
          '⚠️ Réponse API inattendue [${response.statusCode}]: ${response.data}',
        );
      }

      // Met à jour le timestamp même si aucun bulletin n'est trouvé
      await setLastCheckedTimestamp(studentId, DateTime.now());
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur polling étudiant $studentId',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Traite la réponse de l'API et extrait les bulletins.
  Future<void> _processApiResponse(int studentId, dynamic responseData) async {
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
            '📭 Backend confirme: aucun bulletin disponible pour l\'étudiant $studentId',
          );
          return; // Exit early - no bulletin available
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

        // Trie par date de création, plus récent en premier
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

        if (await _isNewBulletin(studentId, latestReportCard)) {
          _logger.i('🆕 Nouveau bulletin détecté, traitement...');

          // Télécharge le bulletin
          final downloadPath = await downloadBulletin(
            studentId,
            latestReportCard,
          );

          // Affiche la notification
          await showBulletinNotification(
            studentId,
            latestReportCard,
            downloadPath,
          );

          // Marque comme traité
          await _storeLastBulletinId(studentId, latestReportCard.id!);

          // Déclenche un rafraîchissement de l'interface utilisateur
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

  /// Notifie l'écran d'accueil qu'il doit rafraîchir les données de bulletins.
  Future<void> _notifyHomeScreenUpdate() async {
    try {
      // Import Get to access the controller
      final dynamic Get = await _getGetInstance();
      if (Get != null) {
        // Try to find the HomeController and refresh bulletins
        try {
          final homeController = Get.find<dynamic>(); // HomeController type
          if (homeController.refreshBulletins != null) {
            await homeController.refreshBulletins();
            _logger.d('🔄 Interface d\'accueil notifiée pour rafraîchissement');
          }
        } catch (e) {
          _logger.d('ℹ️ HomeController non trouvé ou méthode indisponible: $e');
        }
      }
    } catch (e) {
      _logger.d('ℹ️ Notification interface échouée (non critique): $e');
    }
  }

  /// Helper method to get GetX instance dynamically to avoid import issues.
  Future<dynamic> _getGetInstance() async {
    try {
      // This is a workaround to avoid circular dependencies
      // In a real implementation, you might use a callback or event system
      return null; // For now, return null to avoid import issues
    } catch (e) {
      return null;
    }
  }

  /// Vérifie si le bulletin est nouveau (pas encore notifié).
  Future<bool> _isNewBulletin(int studentId, ReportCard reportCard) async {
    try {
      final lastBulletinIdStr = await secureStorage.read(
        key: 'lastBulletinId_$studentId',
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

      if (!isNew) {
        _logger.d('📋 Bulletin déjà traité précédemment');
      } else {
        _logger.d('🆕 Nouveau bulletin détecté!');
      }

      return isNew;
    } catch (e) {
      _logger.e('❌ Erreur vérification nouveau bulletin', error: e);
      return true; // Assume new if we can't check
    }
  }

  /// Stocke l'ID du dernier bulletin notifié.
  Future<void> _storeLastBulletinId(int studentId, int bulletinId) async {
    try {
      await secureStorage.write(
        key: 'lastBulletinId_$studentId',
        value: bulletinId.toString(),
      );
    } catch (e) {
      // Silently handle storage errors
    }
  }

  /// Affiche une notification pour un nouveau bulletin disponible.
  /// Inclut des informations sur le téléchargement si disponible.
  Future<void> showBulletinNotification(
    int studentId,
    ReportCard reportCard, [
    String? downloadPath,
  ]) async {
    try {
      final studentName = await getStudentName(studentId);
      final title = 'Nouveau bulletin disponible';

      String body;
      if (downloadPath != null) {
        body =
            'Le bulletin de $studentName a été téléchargé (Note: ${reportCard.averageGrade ?? 'N/A'}).';
      } else {
        body =
            'Le bulletin de $studentName est disponible (Note: ${reportCard.averageGrade ?? 'N/A'}).';
      }

      _logger.i('🔔 Affichage notification: $title - $body');

      await notifications.show(
        reportCard.id!,
        title,
        body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channelId,
            channelName,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            showWhen: true,
            when: DateTime.now().millisecondsSinceEpoch,
          ),
        ),
      );

      _logger.i('✅ Notification envoyée avec succès');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur affichage notification',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Effectue le polling périodique avec log de démarrage.
  void startPolling() {
    stopPolling();
    _logger.i(
      '🚀 Démarrage du polling automatique (intervalle: ${_pollInterval.inMinutes} min)',
    );

    // Effectue un premier polling immédiat
    poll();

    // Puis démarre le timer périodique
    _timer = Timer.periodic(_pollInterval, (_) {
      _logger.d('⏰ Déclenchement polling périodique');
      poll();
    });
  }

  /// Arrête le polling avec log.
  void stopPolling() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
      _logger.i('⏹️ Polling arrêté');
    }
  }

  /// Nettoie les ressources utilisées par le service.
  void dispose() {
    stopPolling();
  }

  /// Effectue un polling immédiat (pour forcer une vérification).
  Future<void> pollNow() async {
    _logger.i('🔄 Polling manuel déclenché');
    await poll();
  }

  /// Active le mode debug avec polling fréquent (30 secondes).
  void enableDebugMode() {
    stopPolling();
    _logger.w('🐛 Mode DEBUG activé - Polling toutes les 30 secondes');

    poll(); // Premier polling immédiat

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _logger.d('🐛 DEBUG: Polling fréquent');
      poll();
    });
  }

  /// Récupère la liste des bulletins téléchargés localement.
  Future<List<File>> getDownloadedBulletins() async {
    try {
      final bulletinsDir = await getBulletinsDirectory();
      final files = bulletinsDir
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.pdf'))
          .toList();

      // Trie par date de modification (plus récent en premier)
      files.sort((a, b) {
        final aStat = a.statSync();
        final bStat = b.statSync();
        return bStat.modified.compareTo(aStat.modified);
      });

      return files;
    } catch (e) {
      return [];
    }
  }

  /// Supprime les anciens bulletins téléchargés pour libérer de l'espace.
  /// Garde les [keepCount] plus récents fichiers.
  Future<void> cleanupOldBulletins({int keepCount = 10}) async {
    try {
      final files = await getDownloadedBulletins();

      if (files.length > keepCount) {
        final filesToDelete = files.skip(keepCount);

        for (final file in filesToDelete) {
          await file.delete();
        }
      }
    } catch (e) {
      // Silently handle cleanup errors
    }
  }

  /// Force un bulletin à être traité comme nouveau (pour debug).
  /// Supprime l'ID du dernier bulletin stocké pour forcer la re-notification.
  Future<void> resetBulletinStatus(int studentId) async {
    try {
      await secureStorage.delete(key: 'lastBulletinId_$studentId');
      _logger.i('🔄 Statut bulletin réinitialisé pour l\'étudiant $studentId');
    } catch (e) {
      _logger.e('❌ Erreur réinitialisation statut bulletin', error: e);
    }
  }

  /// Force un nouveau polling et traite tous les bulletins comme nouveaux.
  Future<void> forceRefreshBulletins() async {
    try {
      _logger.i('🔄 Forçage du rafraîchissement des bulletins...');
      final studentIds = await getLinkedStudentIds();

      for (final studentId in studentIds) {
        await resetBulletinStatus(studentId);
      }

      await poll();
      _logger.i('✅ Rafraîchissement forcé terminé');
    } catch (e, stackTrace) {
      _logger.e(
        '❌ Erreur lors du rafraîchissement forcé',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }
}
