import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/artists_response.dart';
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
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  final tArtist = Artist(
    id: 'test_id',
    name: 'Test Artist',
    externalUrls: null,
    href: 'test_href',
    uri: 'test_uri',
    popularity: 80,
    followers: null,
    genres: const [],
    images: null,
  );

  final tArtistsResponse = ArtistsResponse(
    href: 'test_href',
    limit: 20,
    offset: 0,
    total: 1,
    items: [tArtist],
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: const [
            ArtistList(),
          ],
        ),
      ),
    );
  }

  group('ArtistList', () {
    testWidgets('should show artists when artist is selected', (tester) async {
      controller.selectArtist();
      controller.artistsResponse.value = tArtistsResponse;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ArtistItem), findsOneWidget);
    });

    testWidgets('should show nothing when only album is selected',
        (tester) async {
      controller.selectAlbum();
      controller.artistsResponse.value = tArtistsResponse;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ArtistItem), findsNothing);
    });

    testWidgets('should show nothing when artists response is empty',
        (tester) async {
      controller.selectArtist();
      controller.artistsResponse.value = ArtistsResponse(
        href: 'test_href',
        limit: 20,
        offset: 0,
        total: 0,
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ArtistItem), findsNothing);
    });

    testWidgets('should show only SizedBox when artists response is null',
        (tester) async {
      controller.selectArtist();
      controller.artistsResponse.value = null;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(ListView), findsNothing);
      expect(find.byType(ArtistItem), findsNothing);

      final SizedBox sizedBox = tester.widget(find.byType(SizedBox));
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });

    testWidgets('should show correct number of artists', (tester) async {
      controller.selectArtist();
      controller.artistsResponse.value = ArtistsResponse(
        href: 'test_href',
        limit: 20,
        offset: 0,
        total: 3,
        items: List.generate(3, (index) => tArtist),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ArtistItem), findsNWidgets(3));
    });
  });
}
