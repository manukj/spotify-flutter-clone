import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/domain/entities/album.dart';
import 'package:spotify_flutter/features/search/domain/entities/albums_response.dart';
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
    Get.put(controller);
  });

  tearDown(() {
    Get.reset();
  });

  final tAlbum = Album(
    albumType: 'album',
    totalTracks: 12,
    availableMarkets: const ['US'],
    externalUrls: null,
    href: 'test_href',
    id: 'test_id',
    images: null,
    name: 'Test Album',
    releaseDate: '2024',
    releaseDatePrecision: 'year',
    type: 'album',
    uri: 'test_uri',
    artists: const [],
  );

  final tAlbumsResponse = AlbumsResponse(
    href: 'test_href',
    limit: 20,
    offset: 0,
    total: 1,
    items: [tAlbum],
  );

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: const [
            AlbumList(),
          ],
        ),
      ),
    );
  }

  group('AlbumList', () {
    testWidgets('should show albums when album is selected', (tester) async {
      controller.selectAlbum();
      controller.albumsResponse.value = tAlbumsResponse;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(AlbumItem), findsOneWidget);
    });

    testWidgets('should show nothing when only artist is selected',
        (tester) async {
      controller.selectArtist();
      controller.albumsResponse.value = tAlbumsResponse;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(AlbumItem), findsNothing);
    });

    testWidgets('should show nothing when albums response is empty',
        (tester) async {
      controller.selectAlbum();
      controller.albumsResponse.value = AlbumsResponse(
        href: 'test_href',
        limit: 20,
        offset: 0,
        total: 0,
        items: [],
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(AlbumItem), findsNothing);
    });

    testWidgets('should show only SizedBox when albums response is null',
        (tester) async {
      controller.selectAlbum();
      controller.albumsResponse.value = null;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(GridView), findsNothing);
      expect(find.byType(AlbumItem), findsNothing);

      final SizedBox sizedBox = tester.widget(find.byType(SizedBox));
      expect(sizedBox.width, 0.0);
      expect(sizedBox.height, 0.0);
    });

    testWidgets('should show correct number of albums', (tester) async {
      controller.selectAlbum();
      controller.albumsResponse.value = AlbumsResponse(
        href: 'test_href',
        limit: 20,
        offset: 0,
        total: 3,
        items: List.generate(3, (index) => tAlbum),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(AlbumItem), findsNWidgets(3));
    });

    testWidgets('should have correct grid layout', (tester) async {
      controller.selectAlbum();
      controller.albumsResponse.value = tAlbumsResponse;

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final GridView gridView = tester.widget(find.byType(GridView));
      final SliverGridDelegateWithFixedCrossAxisCount delegate =
          gridView.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;

      expect(delegate.crossAxisCount, 2);
      expect(delegate.childAspectRatio, 0.8);
      expect(delegate.crossAxisSpacing, 16);
      expect(delegate.mainAxisSpacing, 16);
    });
  });
}
