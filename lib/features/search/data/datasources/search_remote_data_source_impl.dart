import 'package:dio/dio.dart';

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

    return ArtistsResponseModel.fromJson(response.data);
  }

  @override
  Future<AlbumsResponseModel> searchAlbums({
    required String query,
    int? limit,
    int? offset,
  }) async {
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

    return AlbumsResponseModel.fromJson(response.data);
  }
}
