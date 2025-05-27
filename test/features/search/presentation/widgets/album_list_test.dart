import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/domain/entities/album.dart';
import 'package:spotify_flutter/features/search/domain/entities/albums_response.dart';
import 'package:spotify_flutter/features/search/domain/entities/external_urls.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_albums.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_artists.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/album_item.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/album_list.dart';

class MockSearchArtists extends Mock implements SearchArtists {}

class MockSearchAlbums extends Mock implements SearchAlbums {}

void main() {
  late spotify.SearchController controller;
  late MockSearchArtists mockSearchArtists;
  late MockSearchAlbums mockSearchAlbums;

  setUp(() {
    mockSearchArtists = MockSearchArtists();
    mockSearchAlbums = MockSearchAlbums();
    controller = spotify.SearchController(
      searchArtists: mockSearchArtists,
      searchAlbums: mockSearchAlbums,
    );
    Get.put<spotify.SearchController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('should show empty widget when isAlbumSelected is false',
      (WidgetTester tester) async {
    // Arrange
    controller.isAlbumSelected.value = false;
    controller.albumsResponse.value = null;

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AlbumList(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.byKey(const Key('empty_album_widget'), skipOffstage: false),
        findsOneWidget);
  });

  testWidgets('should show empty widget when loading',
      (WidgetTester tester) async {
    // Arrange
    controller.isAlbumSelected.value = true;
    controller.isLoading.value = true;
    controller.albumsResponse.value = AlbumsResponse(
      items: [
        Album(
          id: '1',
          name: 'Test Album',
          artists: [],
          images: [],
          releaseDate: '',
          totalTracks: 1,
          albumType: 'album',
          availableMarkets: ['US'],
          externalUrls:
              ExternalUrls(spotify: 'https://open.spotify.com/album/1'),
          href: 'https://api.spotify.com/v1/albums/1',
          releaseDatePrecision: 'day',
          type: 'album',
          uri: 'spotify:album:1',
        ),
      ],
      href: '',
      limit: 20,
      offset: 0,
      total: 1,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AlbumList(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.byKey(const Key('empty_album_widget'), skipOffstage: false),
        findsOneWidget);
    expect(find.byType(SliverGrid, skipOffstage: false), findsNothing);
  });

  testWidgets('should show grid with albums when data is available',
      (WidgetTester tester) async {
    // Arrange
    controller.isAlbumSelected.value = true;
    controller.isLoading.value = false;
    controller.albumsResponse.value = AlbumsResponse(
      items: [
        Album(
          id: '1',
          name: 'Test Album 1',
          artists: [],
          images: [],
          releaseDate: '',
          totalTracks: 1,
          albumType: 'album',
          availableMarkets: ['US'],
          externalUrls:
              ExternalUrls(spotify: 'https://open.spotify.com/album/1'),
          href: 'https://api.spotify.com/v1/albums/1',
          releaseDatePrecision: 'day',
          type: 'album',
          uri: 'spotify:album:1',
        ),
        Album(
          id: '2',
          name: 'Test Album 2',
          artists: [],
          images: [],
          releaseDate: '',
          totalTracks: 1,
          albumType: 'album',
          availableMarkets: ['US'],
          externalUrls:
              ExternalUrls(spotify: 'https://open.spotify.com/album/2'),
          href: 'https://api.spotify.com/v1/albums/2',
          releaseDatePrecision: 'day',
          type: 'album',
          uri: 'spotify:album:2',
        ),
      ],
      href: '',
      limit: 20,
      offset: 0,
      total: 2,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              AlbumList(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(SliverToBoxAdapter, skipOffstage: false), findsNothing);
    expect(find.byType(SliverGrid, skipOffstage: false), findsOneWidget);
    expect(find.byType(AlbumItem, skipOffstage: false), findsNWidgets(2));
  });
}
