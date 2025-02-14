import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  test('initial state should be empty', () {
    expect(controller.isLoading.value, false);
    expect(controller.query.value, '');
    expect(controller.artistsResponse.value, null);
    expect(controller.albumsResponse.value, null);
    expect(controller.error.value, null);
    expect(controller.isArtistSelected.value, false);
    expect(controller.isAlbumSelected.value, false);
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
      controller.isArtistSelected.value = true;
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchArtists(tQuery)).called(1);
      verifyNever(() => mockSearchAlbums(any()));
      expect(controller.artistsResponse.value, tArtistsResponse);
      expect(controller.albumsResponse.value, null);
      expect(controller.isLoading.value, false);
    });

    test('should call only album search when album is selected', () async {
      controller.isAlbumSelected.value = true;
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchAlbums(tQuery)).called(1);
      verifyNever(() => mockSearchArtists(any()));
      expect(controller.albumsResponse.value, tAlbumsResponse);
      expect(controller.artistsResponse.value, null);
      expect(controller.isLoading.value, false);
    });

    test('should call both searches when neither is selected', () async {
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchArtists(tQuery)).called(1);
      verify(() => mockSearchAlbums(tQuery)).called(1);
      expect(controller.artistsResponse.value, tArtistsResponse);
      expect(controller.albumsResponse.value, tAlbumsResponse);
      expect(controller.isLoading.value, false);
    });

    test('should update state immediately when search query changes', () async {
      controller.onSearchQueryChanged(tQuery);
      
      expect(controller.isLoading.value, true);
      expect(controller.error.value, null);
      expect(controller.query.value, tQuery);
    });

    test('should update state with error when search fails', () async {
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

    test('should debounce multiple rapid calls', () async {
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);

      controller.onSearchQueryChanged('t');
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 100));
      controller.onSearchQueryChanged('te');
      await Future.delayed(const Duration(milliseconds: 100));
      controller.onSearchQueryChanged('tes');
      await Future.delayed(const Duration(milliseconds: 100));
      controller.onSearchQueryChanged(tQuery);

      verifyNever(() => mockSearchArtists(any()));
      verifyNever(() => mockSearchAlbums(any()));

      await Future.delayed(const Duration(milliseconds: 600));

      verify(() => mockSearchArtists(tQuery)).called(1);
      verify(() => mockSearchAlbums(tQuery)).called(1);
      expect(controller.isLoading.value, false);
    });

    test('should cancel previous debounce when cleared', () async {
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);

      controller.onSearchQueryChanged(tQuery);
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 250));
      controller.clearSearch();

      expect(controller.isLoading.value, false);
      await Future.delayed(const Duration(milliseconds: 350));

      verifyNever(() => mockSearchArtists(any()));
      verifyNever(() => mockSearchAlbums(any()));
    });
  });

  group('clearSearch', () {
    test('should reset all state values', () async {
      controller.isArtistSelected.value = true;
      controller.isAlbumSelected.value = true;
      when(() => mockSearchArtists(any())).thenAnswer((_) async => tArtistsResponse);
      when(() => mockSearchAlbums(any())).thenAnswer((_) async => tAlbumsResponse);
      
      controller.onSearchQueryChanged(tQuery);
      await Future.delayed(const Duration(milliseconds: 600));

      controller.clearSearch();

      expect(controller.isLoading.value, false);
      expect(controller.query.value, '');
      expect(controller.artistsResponse.value, null);
      expect(controller.albumsResponse.value, null);
      expect(controller.error.value, null);
      expect(controller.isArtistSelected.value, false);
      expect(controller.isAlbumSelected.value, false);
    });
  });
} 