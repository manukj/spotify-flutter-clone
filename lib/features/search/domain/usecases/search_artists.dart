import '../entities/artists_response.dart';
import '../repositories/music_repository.dart';

class SearchArtists {
  final MusicRepository repository;

  SearchArtists(this.repository);

  Future<ArtistsResponse> call(String query) {
    return repository.searchArtists(query);
  }
} 