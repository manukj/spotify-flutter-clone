import '../entities/artist.dart';
import '../repositories/music_repository.dart';

class SearchArtists {
  final MusicRepository repository;

  SearchArtists(this.repository);

  Future<List<Artist>> call(String query) {
    return repository.searchArtists(query);
  }
} 