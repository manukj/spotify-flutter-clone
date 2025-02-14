import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../../features/search/data/datasources/search_remote_data_source.dart';
import '../../features/search/data/datasources/search_remote_data_source_impl.dart';
import '../../features/search/data/repositories/music_repository_impl.dart';
import '../../features/search/domain/repositories/music_repository.dart';
import '../../features/search/domain/usecases/search_albums.dart';
import '../../features/search/domain/usecases/search_artists.dart';
import '../../features/search/presentation/controllers/search_controller.dart';
import '../network/spotify_dio_interceptor.dart';

class DependencyInjection extends Bindings {
  @override
  void dependencies() {
    
    Get.lazyPut<Dio>(
      () {
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
      },
      fenix: true,
    );

    // Data Sources
    Get.lazyPut<SearchRemoteDataSource>(
      () => SearchRemoteDataSourceImpl(dio: Get.find()),
      fenix: true,
    );

    // Repositories
    Get.lazyPut<MusicRepository>(
      () => MusicRepositoryImpl(remoteDataSource: Get.find()),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
      () => SearchArtists(Get.find()),
      fenix: true,
    );
    Get.lazyPut(
      () => SearchAlbums(Get.find()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut(
      () => SearchController(
        searchArtists: Get.find(),
        searchAlbums: Get.find(),
      ),
      fenix: true,
    );
  }
} 