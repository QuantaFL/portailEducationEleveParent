import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:portail_eleve/app/services/hive_service.dart';

import '../../services/connectivity_controller.dart';
import '../api/api_client.dart';

class ServiceInitializer {
  final Logger logger = Logger();

  /// Client HTTP Dio avec configuration de base (URL, timeouts, en-têtes).
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://10.0.2.2/8000/api/v1',
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
  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await HiveService().init();
    await Get.putAsync(() async => ConnectivityController(), permanent: true);
    final ConnectivityController connectivity =
        Get.find<ConnectivityController>();
    await Get.putAsync(
      () async => ApiClient(
        dio: dio,
        connectivity: connectivity,
        secureStorage: storage,
      ),
      permanent: true,
    );
  }
}
