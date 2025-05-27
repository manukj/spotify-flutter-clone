import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/core/error/exceptions.dart';
import 'package:spotify_flutter/core/network/services/auth_service.dart';
import 'package:spotify_flutter/core/network/spotify_dio_interceptor.dart';

class MockAuthService extends Mock implements AuthService {}

class MockErrorInterceptorHandler extends Mock
    implements ErrorInterceptorHandler {}

class MockRequestInterceptorHandler extends Mock
    implements RequestInterceptorHandler {}

class FakeDioException extends Fake implements DioException {}

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeOptions extends Fake implements Options {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDioException());
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeOptions());
  });

  late SpotifyDioInterceptor interceptor;
  late MockAuthService mockAuthService;
  late MockErrorInterceptorHandler errorHandler;
  late MockRequestInterceptorHandler requestHandler;

  setUp(() {
    mockAuthService = MockAuthService();
    errorHandler = MockErrorInterceptorHandler();
    requestHandler = MockRequestInterceptorHandler();
    interceptor = SpotifyDioInterceptor(mockAuthService);
  });

  group('onRequest', () {
    test('should add authorization header with token', () async {
      // arrange
      const tToken = 'test_token';
      final options = RequestOptions(path: '');
      when(() => mockAuthService.getAccessToken())
          .thenAnswer((_) async => tToken);
      when(() => requestHandler.next(any())).thenAnswer((_) async {});

      // act
      await interceptor.onRequest(options, requestHandler);

      // assert
      expect(options.headers['Authorization'], 'Bearer $tToken');
      verify(() => requestHandler.next(options)).called(1);
    });
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

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.reject(any(
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

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.reject(any(
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

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.reject(any(
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

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.reject(any(
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

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.reject(any(
            that: predicate((DioException e) =>
                e.error is SpotifyException &&
                (e.error as SpotifyException).message ==
                    'Network error occurred'),
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

      interceptor.onError(error, errorHandler);

      verify(() => errorHandler.reject(any(
            that: predicate((DioException e) =>
                e.error is SpotifyException &&
                (e.error as SpotifyException).message ==
                    'Failed to parse error response'),
          ))).called(1);
    });
  });
}
