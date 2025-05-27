import 'package:dio/dio.dart';

import '../../../../core/utils/logger.dart';
import '../models/albums_response_model.dart';
import '../models/artists_response_model.dart';
import 'search_remote_data_source.dart';

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;
  static const baseUrl = 'https://api.spotify.com/v1';

  SearchRemoteDataSourceImpl({required this.dio});

  @override
  Future<ArtistsResponseModel> searchArtists({
    required String query,
    int? limit,
    int? offset,
  }) async {
    logger.i('Searching artists with query: $query, limit: $limit, offset: $offset');
    try {
      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {
          'q': query,
          'type': 'artist',
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      final items = (response.data as Map<String, dynamic>)['artists']?['items'] as List?;
      logger.i('Artists search successful. Found ${items?.length ?? 0} results');
      return ArtistsResponseModel.fromJson(response.data);
    } catch (e) {
      logger.e('Error searching artists', error: e);
      rethrow;
    }
  }

  @override
  Future<AlbumsResponseModel> searchAlbums({
    required String query,
    int? limit,
    int? offset,
  }) async {
    logger.i('Searching albums with query: $query, limit: $limit, offset: $offset');
    try {
      final response = await dio.get(
        '$baseUrl/search',
        queryParameters: {
          'q': query,
          'type': 'album',
          if (limit != null) 'limit': limit,
          if (offset != null) 'offset': offset,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      
      final items = (response.data as Map<String, dynamic>)['albums']?['items'] as List?;
      logger.i('Albums search successful. Found ${items?.length ?? 0} results');
      return AlbumsResponseModel.fromJson(response.data);
    } catch (e) {
      logger.e('Error searching albums', error: e);
      rethrow;
    }
  }
}
