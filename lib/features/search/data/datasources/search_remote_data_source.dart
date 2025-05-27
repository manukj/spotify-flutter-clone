import 'package:spotify_flutter/features/search/data/models/albums_response_model.dart';

import '../models/artists_response_model.dart';

abstract class SearchRemoteDataSource {
  Future<ArtistsResponseModel> searchArtists({
    required String query,
    int? limit,
    int? offset,
  });

  Future<AlbumsResponseModel> searchAlbums({
    required String query,
    int? limit,
    int? offset,
  });
}
