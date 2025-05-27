import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_flutter/core/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    setUp(() async {
      await EnvConfig.load(fileName: 'test/.env.test');
    });

    tearDown(() {
      dotenv.clean();
    });

    test('should load test environment variables', () {
      expect(EnvConfig.spotifyClientId, 'test_client_id');
      expect(EnvConfig.spotifyClientSecret, 'test_client_secret');
    });

    test('should be valid when both variables are set', () {
      expect(EnvConfig.isValid, true);
    });

    test('should return empty string for unset variables', () {
      dotenv.clean();

      expect(EnvConfig.spotifyClientId, '');
      expect(EnvConfig.spotifyClientSecret, '');
    });
  });
}
