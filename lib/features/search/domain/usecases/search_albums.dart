import '../entities/album.dart';
import '../repositories/music_repository.dart';

class SearchAlbums {
  final MusicRepository repository;

  SearchAlbums(this.repository);

  Future<List<Album>> call(String query) {
    return repository.searchAlbums(query);
  }
} 