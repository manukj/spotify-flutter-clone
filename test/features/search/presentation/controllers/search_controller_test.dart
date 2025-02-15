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

  test('initial state should have artist selected and album unselected', () {
    expect(controller.isLoading.value, false);
    expect(controller.query.value, '');
    expect(controller.artistsResponse.value, null);
    expect(controller.albumsResponse.value, null);
    expect(controller.error.value, null);
    expect(controller.isArtistSelected.value, true);
    expect(controller.isAlbumSelected.value, false);
  });

  group('selection behavior', () {
    test('selectArtist should select only artist', () {
      controller.isAlbumSelected.value = true;
      controller.isArtistSelected.value = false;

      controller.selectArtist();

      expect(controller.isArtistSelected.value, true);
      expect(controller.isAlbumSelected.value, false);
    });

    test('selectAlbum should select only album', () {
      controller.isAlbumSelected.value = false;
      controller.isArtistSelected.value = true;

      controller.selectAlbum();

      expect(controller.isArtistSelected.value, false);
      expect(controller.isAlbumSelected.value, true);
    });

    test('clearSearch should reset to default selection state', () {
      controller.isAlbumSelected.value = true;
      controller.isArtistSelected.value = false;

      controller.clearSearch();

      expect(controller.isArtistSelected.value, true);
      expect(controller.isAlbumSelected.value, false);
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

    test('should call only artist search when artist is selected by default', () async {
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
      controller.selectAlbum();
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
      controller.isArtistSelected.value = false;
      controller.isAlbumSelected.value = false;
      
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

      controller.onSearchQueryChanged('t');
      expect(controller.isLoading.value, true);
      
      await Future.delayed(const Duration(milliseconds: 100));
      controller.onSearchQueryChanged('te');
      await Future.delayed(const Duration(milliseconds: 100));
      controller.onSearchQueryChanged('tes');
      await Future.delayed(const Duration(milliseconds: 100));
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
} 