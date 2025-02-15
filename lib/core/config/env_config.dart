import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get spotifyClientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  static String get spotifyClientSecret => dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  static Future<void> load() async {
    await dotenv.load();
  }

  static bool get isValid =>
      spotifyClientId.isNotEmpty && spotifyClientSecret.isNotEmpty;
} 