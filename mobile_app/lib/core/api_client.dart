import 'package:dio/dio.dart';

import 'constants.dart';
import 'token_storage.dart';

/// Thin wrapper around a configured [Dio] instance that:
///  - attaches the JWT access token to every request,
///  - transparently refreshes an expired access token using the refresh
///    token and retries the original request once,
///  - logs the user out (clears tokens) if the refresh itself fails.
class ApiClient {
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {'Accept': 'application/json'},
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await TokenStorage.instance.accessToken;
          if (token != null && !options.path.contains('/auth/login') && !options.path.contains('/auth/register')) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (DioException error, handler) async {
          final isUnauthorized = error.response?.statusCode == 401;
          final isRetry = error.requestOptions.extra['retried'] == true;

          if (isUnauthorized && !isRetry) {
            final refreshed = await _tryRefreshToken();
            if (refreshed) {
              final options = error.requestOptions;
              options.extra['retried'] = true;
              final newToken = await TokenStorage.instance.accessToken;
              options.headers['Authorization'] = 'Bearer $newToken';
              try {
                final response = await _dio.fetch(options);
                return handler.resolve(response);
              } on DioException catch (retryError) {
                return handler.next(retryError);
              }
            } else {
              await TokenStorage.instance.clear();
            }
          }
          handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();
  late final Dio _dio;

  Dio get dio => _dio;

  Future<bool> _tryRefreshToken() async {
    final refresh = await TokenStorage.instance.refreshToken;
    if (refresh == null) return false;
    try {
      final response = await Dio(BaseOptions(baseUrl: ApiConfig.baseUrl)).post(
        '/auth/refresh-token',
        data: {'refresh': refresh},
      );
      final newAccess = response.data['access'] as String?;
      if (newAccess == null) return false;
      await TokenStorage.instance.saveAccessToken(newAccess);
      return true;
    } catch (_) {
      return false;
    }
  }
}

/// Raised by the service layer with a message ready to show to the user.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;

  factory ApiException.fromDioError(DioException e) {
    final data = e.response?.data;
    String message = 'Something went wrong. Please try again.';
    if (data is Map) {
      if (data['detail'] is String) {
        message = data['detail'] as String;
      } else if (data['message'] is String) {
        message = data['message'] as String;
      } else {
        // Field-level validation errors, e.g. {"email": ["already taken"]}
        final firstEntry = data.entries.isNotEmpty ? data.entries.first : null;
        if (firstEntry != null && firstEntry.value is List && (firstEntry.value as List).isNotEmpty) {
          message = '${firstEntry.key}: ${(firstEntry.value as List).first}';
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout || e.type == DioExceptionType.connectionError) {
      message = 'Could not reach the server. Check your internet connection.';
    }
    return ApiException(message, statusCode: e.response?.statusCode);
  }

  @override
  String toString() => message;
}
