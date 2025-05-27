import '../entities/albums_response.dart';
import '../repositories/music_repository.dart';

class SearchAlbums {
  final MusicRepository repository;

  SearchAlbums(this.repository);

  Future<AlbumsResponse> call(String query) {
    return repository.searchAlbums(query);
  }
} 