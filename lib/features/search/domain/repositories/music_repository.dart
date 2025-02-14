import 'package:spotify_flutter/features/search/domain/entities/albums_response.dart';
import 'package:spotify_flutter/features/search/domain/entities/artists_response.dart';

abstract class MusicRepository {
  Future<ArtistsResponse> searchArtists(String query);
  Future<AlbumsResponse> searchAlbums(String query);
} 