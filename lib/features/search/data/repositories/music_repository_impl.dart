import '../../domain/entities/albums_response.dart';
import '../../domain/entities/artists_response.dart';
import '../../domain/repositories/music_repository.dart';
import '../datasources/search_remote_data_source.dart';

class MusicRepositoryImpl implements MusicRepository {
  final SearchRemoteDataSource remoteDataSource;

  MusicRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ArtistsResponse> searchArtists(String query) async {
    final response = await remoteDataSource.searchArtists(
      query: query,
      limit: 20,
      offset: 0,
    );
    return response.toEntity();
  }

  @override
  Future<AlbumsResponse> searchAlbums(String query) async {
    final response = await remoteDataSource.searchAlbums(
      query: query,
      limit: 20,
      offset: 0,
    );
    return response.toEntity();
  }
} 