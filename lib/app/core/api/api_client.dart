import 'package:dio/dio.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../services/connectivity_controller.dart';
import '../interceptors/dio_interceptor.dart';

class ApiClient {
  final Dio dio;
  final FlutterSecureStorage secureStorage;
  final ConnectivityController connectivity;

  ApiClient({
    required this.dio,
    required this.secureStorage,
    required this.connectivity,
  }) {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    dio.interceptors.clear();

    dio.interceptors.addAll([
      AuthInterceptor(secureStorage),
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retries: 3,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 4),
        ],
        retryEvaluator: (error, _) =>
            error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.connectionError,
      ),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
      ),
    ]);
  }

  /// Génère un nouveau [CancelToken] permettant d'annuler une requête en cours.
  CancelToken generateCancelToken() => CancelToken();

  /// Envoie une requête HTTP GET à l'URL spécifiée.
  ///
  /// [path] : le chemin ou l'URL relative de la requête.
  /// [queryParams] : les paramètres de requête facultatifs à inclure dans l'URL.
  /// [cancelToken] : un jeton permettant d'annuler la requête si nécessaire.
  ///
  /// Retourne une réponse de type [Response<T>].
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParams,
    CancelToken? cancelToken,
  }) {
    return dio.get<T>(
      path,
      queryParameters: queryParams,
      cancelToken: cancelToken,
    );
  }

  /// Envoie une requête HTTP POST à l'URL spécifiée avec des données facultatives.
  ///
  /// [path] : le chemin ou l'URL relative de la requête.
  /// [data] : les données à envoyer dans le corps de la requête.
  /// [cancelToken] : un jeton permettant d'annuler la requête si nécessaire.
  ///
  /// Retourne une réponse de type [Response<T>].
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    CancelToken? cancelToken,
  }) {
    return dio.post<T>(path, data: data, cancelToken: cancelToken);
  }
}
