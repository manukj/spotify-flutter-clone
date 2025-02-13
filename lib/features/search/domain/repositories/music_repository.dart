import '../entities/album.dart';
import '../entities/artist.dart';

abstract class MusicRepository {
  Future<List<Artist>> searchArtists(String query);
  Future<List<Album>> searchAlbums(String query);
} 