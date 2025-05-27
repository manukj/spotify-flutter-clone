import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

import '../../config/env_config.dart';
import '../models/token_response.dart';

class AuthService {
  static const _tokenKey = 'spotify_token';
  static const _expiryKey = 'spotify_token_expiry';
  final GetStorage _storage;
  final Dio _authDio;

  AuthService({
    GetStorage? storage,
    Dio? authDio,
  }) : _storage = storage ?? GetStorage(),
       _authDio = authDio ?? Dio(BaseOptions(
         baseUrl: 'https://accounts.spotify.com/api',
         contentType: 'application/x-www-form-urlencoded',
       ));

  Future<String> getAccessToken() async {
    final storedToken = _storage.read<String>(_tokenKey);
    final expiryTime = _storage.read<String>(_expiryKey);

    if (storedToken != null && expiryTime != null) {
      final expiry = DateTime.parse(expiryTime);
      if (expiry.isAfter(DateTime.now().add(const Duration(minutes: 1)))) {
        return storedToken;
      }
    }

    return _refreshToken();
  }

  Future<String> _refreshToken() async {
    final credentials = base64Encode(
      utf8.encode('${EnvConfig.spotifyClientId}:${EnvConfig.spotifyClientSecret}'),
    );

    final response = await _authDio.post(
      '/token',
      data: {'grant_type': 'client_credentials'},
      options: Options(
        headers: {'Authorization': 'Basic $credentials'},
      ),
    );

    final tokenResponse = TokenResponse.fromJson(response.data);
    final expiryTime = DateTime.now().add(Duration(seconds: tokenResponse.expiresIn));

    await _storage.write(_tokenKey, tokenResponse.accessToken);
    await _storage.write(_expiryKey, expiryTime.toIso8601String());

    return tokenResponse.accessToken;
  }
} 