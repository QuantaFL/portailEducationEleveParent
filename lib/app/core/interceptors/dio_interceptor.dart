import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Intercepteur Dio pour ajouter automatiquement le jeton d'authentification
/// dans les en-têtes des requêtes HTTP sortantes.
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage secureStorage;

  AuthInterceptor(this.secureStorage);

  /// Intercepte les requêtes HTTP avant l'envoi.
  ///
  /// Lit le jeton d'authentification depuis le stockage sécurisé.
  /// Si le jeton est présent, l'ajoute dans l'en-tête `Authorization` au format `Bearer`.
  ///
  /// [options] : les options de la requête.
  /// [handler] : gestionnaire pour continuer ou arrêter la requête.
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.read(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }
}
