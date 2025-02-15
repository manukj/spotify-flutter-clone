import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_albums.dart';
import 'package:spotify_flutter/features/search/domain/usecases/search_artists.dart';
import 'package:spotify_flutter/features/search/presentation/controllers/search_controller.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/filter_chip.dart';

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
      home: Scaffold(
        body: SpotifyFilterChips(),
      ),
    );
  }

  group('SpotifyFilterChips', () {
    testWidgets('should display both filter chips', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(FilterChip), findsNWidgets(2));
      expect(find.text('Artists'), findsOneWidget);
      expect(find.text('Albums'), findsOneWidget);
    });

    testWidgets('should have artist chip selected by default', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final artistChip = tester.widget<FilterChip>(
        find.ancestor(
          of: find.text('Artists'),
          matching: find.byType(FilterChip),
        ),
      );

      expect(artistChip.selected, isTrue);
    });

    testWidgets('should select album chip when tapped', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      await tester.tap(find.text('Albums'));
      await tester.pumpAndSettle();

      final albumChip = tester.widget<FilterChip>(
        find.ancestor(
          of: find.text('Albums'),
          matching: find.byType(FilterChip),
        ),
      );

      expect(albumChip.selected, isTrue);
      expect(controller.isAlbumSelected.value, isTrue);
      expect(controller.isArtistSelected.value, isFalse);
    });

    testWidgets('should select artist chip when tapped after album',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      // First select album
      await tester.tap(find.text('Albums'));
      await tester.pumpAndSettle();

      // Then select artist
      await tester.tap(find.text('Artists'));
      await tester.pumpAndSettle();

      final artistChip = tester.widget<FilterChip>(
        find.ancestor(
          of: find.text('Artists'),
          matching: find.byType(FilterChip),
        ),
      );

      expect(artistChip.selected, isTrue);
      expect(controller.isArtistSelected.value, isTrue);
      expect(controller.isAlbumSelected.value, isFalse);
    });

    testWidgets('should have correct styling when selected', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final artistChip = tester.widget<FilterChip>(
        find.ancestor(
          of: find.text('Artists'),
          matching: find.byType(FilterChip),
        ),
      );

      expect(artistChip.backgroundColor, Colors.white.withOpacity(0.1));
      expect(artistChip.selectedColor, const Color(0xFF1DB954));
      expect(artistChip.selected, isTrue);
    });

    testWidgets('should have correct colors for both chips', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      final artistChip = tester.widget<FilterChip>(
        find.ancestor(
          of: find.text('Artists'),
          matching: find.byType(FilterChip),
        ),
      );

      final albumChip = tester.widget<FilterChip>(
        find.ancestor(
          of: find.text('Albums'),
          matching: find.byType(FilterChip),
        ),
      );

      expect(artistChip.backgroundColor, Colors.white.withOpacity(0.1));
      expect(artistChip.selectedColor, const Color(0xFF1DB954));
      expect(artistChip.selected, isTrue);
      expect(albumChip.selected, isFalse);
    });
  });
}
