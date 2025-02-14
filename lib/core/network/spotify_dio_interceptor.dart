import 'package:dio/dio.dart';

import '../../features/search/data/models/spotify_error_response.dart';
import '../error/exceptions.dart';

class SpotifyDioInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      try {
        final errorResponse = SpotifyErrorResponse.fromJson(err.response!.data);
        final exception = _handleErrorStatus(
          statusCode: err.response!.statusCode ?? errorResponse.error.status,
          message: errorResponse.error.message,
        );
        handler.reject(err.copyWith(error: exception));
      } catch (e) {
        handler.reject(
          err.copyWith(
            error: SpotifyException(
              message: 'Failed to parse error response',
              statusCode: err.response?.statusCode ?? 500,
            ),
          ),
        );
      }
    } else {
      handler.reject(
        err.copyWith(
          error: SpotifyException(
            message: 'Network error occurred',
            statusCode: 500,
          ),
        ),
      );
    }
  }

  Exception _handleErrorStatus({
    required int statusCode,
    required String message,
  }) {
    switch (statusCode) {
      case 401:
        return UnauthorizedException(message: message);
      case 403:
        return ForbiddenException(message: message);
      case 429:
        return RateLimitException(message: message);
      default:
        return SpotifyException(
          message: message,
          statusCode: statusCode,
        );
    }
  }
} 