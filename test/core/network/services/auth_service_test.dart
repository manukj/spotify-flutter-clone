import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/core/network/services/auth_service.dart';

class MockDio extends Mock implements Dio {}

class MockGetStorage extends Mock implements GetStorage {}

class MockResponse extends Mock implements Response {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await dotenv.load(fileName: 'test/.env.test');
  });

  late AuthService authService;
  late MockDio mockDio;
  late MockGetStorage mockStorage;

  setUp(() {
    mockDio = MockDio();
    mockStorage = MockGetStorage();
    authService = AuthService(
      storage: mockStorage,
      authDio: mockDio,
    );
  });

  group('getAccessToken', () {
    const tToken = 'test_token';
    final tExpiry = DateTime.now().add(const Duration(hours: 1));
    final tExpiryString = tExpiry.toIso8601String();

    test('should return stored token when it is valid', () async {
      when(() => mockStorage.read<String>('spotify_token')).thenReturn(tToken);
      when(() => mockStorage.read<String>('spotify_token_expiry'))
          .thenReturn(tExpiryString);

      final result = await authService.getAccessToken();

      expect(result, tToken);
      verifyNever(() => mockDio.post(any()));
    });

    test('should refresh token when stored token is expired', () async {
      final expiredExpiry = DateTime.now().subtract(const Duration(minutes: 5));
      when(() => mockStorage.read<String>('spotify_token')).thenReturn(tToken);
      when(() => mockStorage.read<String>('spotify_token_expiry'))
          .thenReturn(expiredExpiry.toIso8601String());

      when(() => mockDio.post(
            '/token',
            data: {'grant_type': 'client_credentials'},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'access_token': 'new_token',
              'token_type': 'Bearer',
              'expires_in': 3600,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      when(() => mockStorage.write(any(), any())).thenAnswer((_) async {});

      final result = await authService.getAccessToken();

      expect(result, 'new_token');

      verify(() => mockDio.post(
            '/token',
            data: {'grant_type': 'client_credentials'},
            options: any(named: 'options'),
          )).called(1);
    });

    test('should refresh token when no token is stored', () async {
      // arrange
      when(() => mockStorage.read<String>('spotify_token')).thenReturn(null);
      when(() => mockStorage.read<String>('spotify_token_expiry'))
          .thenReturn(null);

      when(() => mockDio.post(
            '/token',
            data: {'grant_type': 'client_credentials'},
            options: any(named: 'options'),
          )).thenAnswer((_) async => Response(
            data: {
              'access_token': 'new_token',
              'token_type': 'Bearer',
              'expires_in': 3600,
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));
      when(() => mockStorage.write(any(), any())).thenAnswer((_) async {});

      // act
      final result = await authService.getAccessToken();

      // assert
      expect(result, 'new_token');

      verify(() => mockDio.post(
            '/token',
            data: {'grant_type': 'client_credentials'},
            options: any(named: 'options'),
          )).called(1);

      // Verify storage writes
      verify(() => mockStorage.write('spotify_token', 'new_token')).called(1);
      verify(() => mockStorage.write('spotify_token_expiry', any())).called(1);
    });
  });
}
