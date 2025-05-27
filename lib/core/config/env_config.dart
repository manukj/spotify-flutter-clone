import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get spotifyClientId => dotenv.env['SPOTIFY_CLIENT_ID'] ?? '';
  static String get spotifyClientSecret =>
      dotenv.env['SPOTIFY_CLIENT_SECRET'] ?? '';

  static Future<void> load({String? fileName}) async {
    await dotenv.load(fileName: fileName ?? '.env');
  }

  static bool get isValid =>
      spotifyClientId.isNotEmpty && spotifyClientSecret.isNotEmpty;
}
