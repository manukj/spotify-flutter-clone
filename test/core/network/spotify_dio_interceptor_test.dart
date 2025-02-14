import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/core/error/exceptions.dart';
import 'package:spotify_flutter/core/network/spotify_dio_interceptor.dart';

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class FakeDioException extends Fake implements DioException {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDioException());
    registerFallbackValue(FakeRequestOptions());
  });

  late SpotifyDioInterceptor interceptor;
  late MockErrorInterceptorHandler handler;

  setUp(() {
    interceptor = SpotifyDioInterceptor();
    handler = MockErrorInterceptorHandler();
  });

  group('onError', () {
    test('should handle 401 error correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {
            'error': {
              'status': 401,
              'message': 'Invalid token',
            }
          },
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(error, handler);

      verify(() => handler.reject(any(
            that: predicate((DioException e) =>
                e.error is UnauthorizedException &&
                (e.error as UnauthorizedException).message == 'Invalid token'),
          ))).called(1);
    });

    test('should handle 403 error correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {
            'error': {
              'status': 403,
              'message': 'Forbidden',
            }
          },
          statusCode: 403,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(error, handler);

      verify(() => handler.reject(any(
            that: predicate((DioException e) =>
                e.error is ForbiddenException &&
                (e.error as ForbiddenException).message == 'Forbidden'),
          ))).called(1);
    });

    test('should handle 429 error correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {
            'error': {
              'status': 429,
              'message': 'Rate limit exceeded',
            }
          },
          statusCode: 429,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(error, handler);

      verify(() => handler.reject(any(
            that: predicate((DioException e) =>
                e.error is RateLimitException &&
                (e.error as RateLimitException).message ==
                    'Rate limit exceeded'),
          ))).called(1);
    });

    test('should handle generic error correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {
            'error': {
              'status': 400,
              'message': 'Bad request',
            }
          },
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(error, handler);

      verify(() => handler.reject(any(
            that: predicate((DioException e) =>
                e.error is SpotifyException &&
                (e.error as SpotifyException).message == 'Bad request' &&
                (e.error as SpotifyException).statusCode == 400),
          ))).called(1);
    });

    test('should handle network error correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
      );

      interceptor.onError(error, handler);

      verify(() => handler.reject(any(
            that: predicate((DioException e) =>
                e.error is SpotifyException &&
                (e.error as SpotifyException).message ==
                    'Network error occurred' &&
                (e.error as SpotifyException).statusCode == 500),
          ))).called(1);
    });

    test('should handle malformed error response correctly', () {
      final error = DioException(
        requestOptions: RequestOptions(path: ''),
        response: Response(
          data: {'invalid': 'format'},
          statusCode: 400,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(error, handler);

      verify(() => handler.reject(any(
            that: predicate((DioException e) =>
                e.error is SpotifyException &&
                (e.error as SpotifyException).message ==
                    'Failed to parse error response'),
          ))).called(1);
    });
  });
}
