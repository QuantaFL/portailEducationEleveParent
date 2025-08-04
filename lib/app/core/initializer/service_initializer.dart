import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/repositories/bulletin_repository.dart';
import 'package:portail_eleve/app/core/data/repositories/student_repository.dart';
import 'package:portail_eleve/app/core/services/parent_service.dart';
import 'package:portail_eleve/app/modules/parent_home/data/useCases/parent_poll_latest_bulletins.dart';
import 'package:portail_eleve/app/services/auto_refresh_service.dart';
import 'package:portail_eleve/app/services/connectivity_controller.dart';
import 'package:portail_eleve/app/services/hive_service.dart';
import 'package:portail_eleve/app/services/notification_service.dart';

class ServiceInitializer {
  final Logger logger = Logger();

  /// Client HTTP Dio avec configuration de base (URL, timeouts, en-têtes).
  final Dio dio = Dio(
    BaseOptions(
      // baseUrl: 'http://10.0.2.2:8000/api/v1',
      baseUrl: "https://gestionecole-main-utpepe.laravel.cloud/api/v1",
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  /// Stockage sécurisé pour sauvegarder les données sensibles localement.
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  /// Initialise tous les services nécessaires à l'application.
  ///
  /// - Initialise les widgets Flutter.
  /// - Initialise Hive pour le stockage local.
  /// - Enregistre les adaptateurs Hive pour les modèles personnalisés.
  /// - Ouvre les boîtes Hive correspondantes.
  /// - Instancie et enregistre le contrôleur de connectivité avec GetX.
  /// - Instancie et enregistre le client API avec ses dépendances.
  /// - Enregistre le service ParentService.
  /// - Enregistre les services de notification et de rafraîchissement automatique.
  /// - Enregistre le service de polling des bulletins parent.
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveService().init();
    await Get.putAsync(() async => ConnectivityController(), permanent: true);
    final ConnectivityController connectivity =
        Get.find<ConnectivityController>();
    final apiClient = await Get.putAsync(
      () async => ApiClient(
        dio: dio,
        connectivity: connectivity,
        secureStorage: storage,
      ),
      permanent: true,
    );
    Get.lazyPut(() => StudentRepository(apiClient: apiClient));
    Get.lazyPut(() => BulletinRepository(apiClient: apiClient));
    Get.put<ParentService>(ParentService(), permanent: true);

    // Initialize notification and auto-refresh services
    await Get.putAsync(() async => NotificationService(), permanent: true);
    await Get.putAsync(() async => AutoRefreshService(), permanent: true);

    // Initialize parent bulletin polling service
    final notificationPlugin = FlutterLocalNotificationsPlugin();
    await Get.putAsync(
      () async => ParentPollLatestBulletins(
        apiClient: apiClient,
        notifications: notificationPlugin,
      ),
      permanent: true,
    );
  }
}
