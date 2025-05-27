import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/core/error/exceptions.dart';
import 'package:spotify_flutter/features/search/domain/entities/albums_response.dart';
import 'package:spotify_flutter/features/search/domain/entities/artists_response.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_albums.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_artists.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart';

class MockSearchArtists extends Mock implements SearchArtists {}
class MockSearchAlbums extends Mock implements SearchAlbums {}

void main() {
  late SearchController controller;
  late MockSearchArtists mockSearchArtists;
  late MockSearchAlbums mockSearchAlbums;

  setUp(() {
    mockSearchArtists = MockSearchArtists();
    mockSearchAlbums = MockSearchAlbums();
    controller = SearchController(
      searchArtists: mockSearchArtists,
      searchAlbums: mockSearchAlbums,
    );
  });

  tearDown(() {
    controller.onClose();
  });

  const tQuery = 'test query';
  final tArtistsResponse = ArtistsResponse(
    href: 'test_href',
    limit: 20,
    offset: 0,
    total: 1,
    items: [],
  );
  final tAlbumsResponse = AlbumsResponse(
    href: 'test_href',
    limit: 20,
    offset: 0,
    total: 1,
    items: [],
  );

  group('initial state', () {
    test('should have artist selected and album unselected', () {
      expect(controller.isLoading.value, false);
      expect(controller.query.value, '');
      expect(controller.artistsResponse.value, null);
      expect(controller.albumsResponse.value, null);
      expect(controller.error.value, null);
      expect(controller.isArtistSelected.value, true);
      expect(controller.isAlbumSelected.value, false);
    });
  });

  group('selection behavior', () {
    test('selectArtist should not trigger search if already selected', () {
      controller.isArtistSelected.value = true;
      controller.isAlbumSelected.value = false;
      controller.query.value = tQuery;

      controller.selectArtist();

      verifyNever(() => mockSearchArtists(any()));
      expect(controller.isArtistSelected.value, true);
      expect(controller.isAlbumSelected.value, false);
    });

    test('selectAlbum should not trigger search if already selected', () {
      controller.isAlbumSelected.value = true;
      controller.isArtistSelected.value = false;
      controller.query.value = tQuery;

      controller.selectAlbum();

      verifyNever(() => mockSearchAlbums(any()));
      expect(controller.isArtistSelected.value, false);
      expect(controller.isAlbumSelected.value, true);
    });

    test('selectArtist should trigger search if has query and no data', () async {
      controller.isAlbumSelected.value = true;
      controller.isArtistSelected.value = false;
      controller.query.value = tQuery;
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);

      controller.selectArtist();
      await Future.delayed(Duration.zero);

      verify(() => mockSearchArtists(tQuery)).called(1);
      expect(controller.isArtistSelected.value, true);
      expect(controller.isAlbumSelected.value, false);
    });

    test('selectAlbum should trigger search if has query and no data', () async {
      controller.isArtistSelected.value = true;
      controller.isAlbumSelected.value = false;
      controller.query.value = tQuery;
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);

      controller.selectAlbum();
      await Future.delayed(Duration.zero);

      verify(() => mockSearchAlbums(tQuery)).called(1);
      expect(controller.isArtistSelected.value, false);
      expect(controller.isAlbumSelected.value, true);
    });
  });

  group('onSearchQueryChanged', () {
    test('should not trigger search for empty query', () async {
      controller.onSearchQueryChanged('');
      await Future.delayed(const Duration(milliseconds: 600));

      verifyNever(() => mockSearchArtists(any()));
      verifyNever(() => mockSearchAlbums(any()));
      expect(controller.isLoading.value, false);
    });

    test('should call only artist search when artist is selected', () async {
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchArtists(tQuery)).called(1);
      verifyNever(() => mockSearchAlbums(any()));
      expect(controller.artistsResponse.value, tArtistsResponse);
      expect(controller.isLoading.value, false);
    });

    test('should call only album search when album is selected', () async {
      controller.selectAlbum();
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchAlbums(tQuery)).called(1);
      verifyNever(() => mockSearchArtists(any()));
      expect(controller.albumsResponse.value, tAlbumsResponse);
      expect(controller.isLoading.value, false);
    });

    test('should handle error correctly for artist search', () async {
      final tError = Exception('test error');
      when(() => mockSearchArtists(any())).thenThrow(tError);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      expect(controller.isLoading.value, false);
      expect(controller.error.value, tError.toString());
      expect(controller.artistsResponse.value, null);
      expect(controller.albumsResponse.value, null);
    });

    test('should handle error correctly for album search', () async {
      controller.selectAlbum();
      final tError = Exception('test error');
      when(() => mockSearchAlbums(any())).thenThrow(tError);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      expect(controller.isLoading.value, false);
      expect(controller.error.value, tError.toString());
      expect(controller.artistsResponse.value, null);
      expect(controller.albumsResponse.value, null);
    });

    test('should debounce multiple rapid calls', () async {
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);

      controller.onSearchQueryChanged('t');
      controller.onSearchQueryChanged('te');
      controller.onSearchQueryChanged('tes');
      controller.onSearchQueryChanged(tQuery);
      
      verifyNever(() => mockSearchArtists(any()));
      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchArtists(tQuery)).called(1);
      expect(controller.isLoading.value, false);
    });

    test('should cancel previous debounce when cleared', () async {
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 250));
      controller.clearSearch();

      expect(controller.isLoading.value, false);
      await Future.delayed(const Duration(milliseconds: 350));

      verifyNever(() => mockSearchArtists(any()));
    });
  });

  group('error handling', () {
    test('should handle SpotifyException correctly for artist search', () async {
      final spotifyError = SpotifyException(
        message: 'Invalid token',
        statusCode: 401,
      );
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        error: spotifyError,
      );
      
      when(() => mockSearchArtists(any())).thenThrow(dioError);

      controller.onSearchQueryChanged(tQuery);
      await Future.delayed(const Duration(milliseconds: 600));

      expect(controller.error.value, spotifyError.message);
      expect(controller.artistsResponse.value, null);
    });

    test('should handle SpotifyException correctly for album search', () async {
      controller.selectAlbum();
      
      final spotifyError = SpotifyException(
        message: 'Rate limit exceeded',
        statusCode: 429,
      );
      final dioError = DioException(
        requestOptions: RequestOptions(path: ''),
        error: spotifyError,
      );
      
      when(() => mockSearchAlbums(any())).thenThrow(dioError);

      controller.onSearchQueryChanged(tQuery);
      await Future.delayed(const Duration(milliseconds: 600));

      expect(controller.error.value, spotifyError.message);
      expect(controller.albumsResponse.value, null);
    });

    test('should handle generic error correctly', () async {
      final error = Exception('Generic error');
      when(() => mockSearchArtists(any())).thenThrow(error);

      controller.onSearchQueryChanged(tQuery);
      await Future.delayed(const Duration(milliseconds: 600));

      expect(controller.error.value, error.toString());
      expect(controller.artistsResponse.value, null);
    });
  });
} 