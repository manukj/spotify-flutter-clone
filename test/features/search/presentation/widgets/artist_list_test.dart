import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/artists_response.dart';
import 'package:spotify_flutter/features/search/domain/entities/external_urls.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_albums.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_artists.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/artist_item.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/artist_list.dart';

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

  testWidgets('should show empty widget when isArtistSelected is false',
      (WidgetTester tester) async {
    // Arrange
    controller.isArtistSelected.value = false;
    controller.artistsResponse.value = null;

    // Act
    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: CustomScrollView(
            slivers: [
              ArtistList(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.byKey(const Key('empty_artist_widget'), skipOffstage: false), findsOneWidget);
  });

  testWidgets('should show empty widget when loading',
      (WidgetTester tester) async {
    // Arrange
    controller.isArtistSelected.value = true;
    controller.isLoading.value = true;
    controller.artistsResponse.value = ArtistsResponse(
      items: [
        Artist(
          id: '1',
          name: 'Test Artist',
          externalUrls: ExternalUrls(spotify: 'https://open.spotify.com/artist/1'),
          href: 'https://api.spotify.com/v1/artists/1',
          uri: 'spotify:artist:1',
          popularity: 80,
          followers: null,
          genres: const [],
          images: [],
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
              ArtistList(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.byKey(const Key('empty_artist_widget'), skipOffstage: false), findsOneWidget);
    expect(find.byType(SliverList, skipOffstage: false), findsNothing);
  });

  testWidgets('should show list with artists when data is available',
      (WidgetTester tester) async {
    // Arrange
    controller.isArtistSelected.value = true;
    controller.isLoading.value = false;
    controller.artistsResponse.value = ArtistsResponse(
      items: [
        Artist(
          id: '1',
          name: 'Test Artist 1',
          externalUrls: ExternalUrls(spotify: 'https://open.spotify.com/artist/1'),
          href: 'https://api.spotify.com/v1/artists/1',
          uri: 'spotify:artist:1',
          popularity: 80,
          followers: null,
          genres: const [],
          images: [],
        ),
        Artist(
          id: '2',
          name: 'Test Artist 2',
          externalUrls: ExternalUrls(spotify: 'https://open.spotify.com/artist/2'),
          href: 'https://api.spotify.com/v1/artists/2',
          uri: 'spotify:artist:2',
          popularity: 75,
          followers: null,
          genres: const [],
          images: [],
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
              ArtistList(),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(SliverToBoxAdapter, skipOffstage: false), findsNothing);
    expect(find.byType(SliverList, skipOffstage: false), findsOneWidget);
    expect(find.byType(ArtistItem, skipOffstage: false), findsNWidgets(2));
  });
}
