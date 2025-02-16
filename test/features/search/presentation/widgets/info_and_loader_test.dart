import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/domain/entities/album.dart';
import 'package:spotify_flutter/features/search/domain/entities/albums_response.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/artists_response.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_albums.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_artists.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/info_and_loader.dart';

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
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: Column(
          children: [
            InfoAndLoader(),
          ],
        ),
      ),
    );
  }

  group('InfoMessage - Loading State', () {
    testWidgets('should show loading indicator when loading', (tester) async {
      controller.isLoading.value = true;
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Search'), findsNothing);
      expect(find.text('Couldn\'t find'), findsNothing);
    });
  });

  group('InfoMessage - Empty Search State', () {
    testWidgets('should show empty search state with artists by default',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Artists'), findsOneWidget);
      expect(find.text('Albums'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show empty search state with albums when selected',
        (tester) async {
      controller.selectAlbum();
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search'), findsOneWidget);
      expect(find.text('Albums'), findsOneWidget);
      expect(find.text('Artists'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should update empty search state when selection changes',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      expect(find.text('Artists'), findsOneWidget);

      controller.selectAlbum();
      await tester.pump();
      expect(find.text('Albums'), findsOneWidget);

      controller.selectArtist();
      await tester.pump();
      expect(find.text('Artists'), findsOneWidget);
    });
  });

  group('InfoMessage - No Results State', () {
    testWidgets('should show no results for artists when search has no results',
        (tester) async {
      controller.query.value = 'test';
      controller.artistsResponse.value = ArtistsResponse(
        href: '',
        limit: 20,
        offset: 0,
        total: 0,
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Couldn\'t find "Artists"'), findsOneWidget);
      expect(find.text('Go online to search again.'), findsOneWidget);
      expect(find.text('Search'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show no results for albums when search has no results',
        (tester) async {
      controller.selectAlbum();
      controller.query.value = 'test';
      controller.albumsResponse.value = AlbumsResponse(
        href: '',
        limit: 20,
        offset: 0,
        total: 0,
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Couldn\'t find "Albums"'), findsOneWidget);
      expect(find.text('Go online to search again.'), findsOneWidget);
      expect(find.text('Search'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should not show no results when query is empty',
        (tester) async {
      controller.query.value = '';
      controller.artistsResponse.value = ArtistsResponse(
        href: '',
        limit: 20,
        offset: 0,
        total: 0,
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Couldn\'t find'), findsNothing);
      expect(find.text('Go online to search again.'), findsNothing);
      expect(find.text('Search'), findsOneWidget);
    });
  });

  group('InfoMessage - Error State', () {
    testWidgets('should show error state with custom message', (tester) async {
      controller.error.value = 'Test error message';
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Test error message'), findsOneWidget);
      expect(find.text('Search'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('should show error state with default message when null',
        (tester) async {
      controller.error.value = null;
      controller.query.value = 'test';
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Something went wrong'), findsNothing);
      expect(find.text('Please try again.'), findsNothing);
    });

    testWidgets('should prioritize error state over no results',
        (tester) async {
      controller.error.value = 'Error message';
      controller.query.value = 'test';
      controller.artistsResponse.value = ArtistsResponse(
        href: '',
        limit: 20,
        offset: 0,
        total: 0,
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Something went wrong'), findsOneWidget);
      expect(find.text('Error message'), findsOneWidget);
      expect(find.text('Couldn\'t find'), findsNothing);
    });
  });

  group('InfoMessage - Results Available State', () {
    testWidgets('should show nothing when artist results are available',
        (tester) async {
      controller.query.value = 'test';
      controller.isArtistSelected.value = true;
      controller.artistsResponse.value = ArtistsResponse(
        href: '',
        limit: 20,
        offset: 0,
        total: 1,
        items: [
          const Artist(
            id: '1',
            name: 'Test Artist',
            externalUrls: null,
            href: '',
            uri: '',
            popularity: 0,
            followers: null,
            genres: [],
            images: null,
          ),
        ],
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search'), findsNothing);
      expect(find.text('artists'), findsNothing);
      expect(find.text('albums'), findsNothing);
      expect(find.text('Couldn\'t find'), findsNothing);
      expect(find.text('Go online to search again.'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(InfoAndLoader),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 0);
      expect(sizedBox.height, 0);
    });

    testWidgets('should show nothing when album results are available',
        (tester) async {
      controller.selectAlbum();
      controller.query.value = 'test';
      controller.isArtistSelected.value = false;
      controller.isAlbumSelected.value = true;
      controller.albumsResponse.value = AlbumsResponse(
        href: '',
        limit: 20,
        offset: 0,
        total: 1,
        items: [
          const Album(
            albumType: 'album',
            totalTracks: 1,
            availableMarkets: ['US'],
            externalUrls: null,
            href: 'test_href',
            id: '1',
            images: null,
            name: 'Test Album',
            releaseDate: '2024',
            releaseDatePrecision: 'year',
            type: 'album',
            uri: 'test_uri',
            artists: [],
          ),
        ],
      );

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Search'), findsNothing);
      expect(find.text('artists'), findsNothing);
      expect(find.text('albums'), findsNothing);
      expect(find.text('Couldn\'t find'), findsNothing);
      expect(find.text('Go online to search again.'), findsNothing);
      expect(find.text('Something went wrong'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(InfoAndLoader),
          matching: find.byType(SizedBox),
        ),
      );
      expect(sizedBox.width, 0);
      expect(sizedBox.height, 0);
    });
  });
}
