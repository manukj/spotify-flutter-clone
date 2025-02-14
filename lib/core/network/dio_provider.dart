import 'package:dio/dio.dart';

import 'spotify_dio_interceptor.dart';

class DioProvider {
  static Dio provideDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.spotify.com/v1',
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    dio.interceptors.add(SpotifyDioInterceptor());
    
    return dio;
  }
} 