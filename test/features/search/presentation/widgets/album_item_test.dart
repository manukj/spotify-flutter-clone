import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_flutter/features/search/domain/entities/album.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/image.dart'
    as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/album_item.dart';

void main() {
  final tAlbumWithType = Album(
    albumType: 'Single',
    totalTracks: 1,
    availableMarkets: const ['US'],
    externalUrls: null,
    href: '',
    id: '1',
    images: [
      const spotify.Image(
        url: 'https://example.com/image.jpg',
        height: 300,
        width: 300,
      ),
    ],
    name: 'Million Miles',
    releaseDate: '2020',
    releaseDatePrecision: 'year',
    type: 'album',
    uri: '',
    artists: [
      const Artist(
        id: '1',
        name: 'Angelina Jordan',
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

  final tAlbumWithoutType = Album(
    albumType: '',
    totalTracks: 1,
    availableMarkets: const ['US'],
    externalUrls: null,
    href: '',
    id: '1',
    images: [
      const spotify.Image(
        url: 'https://example.com/image.jpg',
        height: 300,
        width: 300,
      ),
    ],
    name: 'Million Miles',
    releaseDate: '2020',
    releaseDatePrecision: 'year',
    type: 'album',
    uri: '',
    artists: [
      const Artist(
        id: '1',
        name: 'Angelina Jordan',
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

  Widget createWidgetUnderTest({required Album album, VoidCallback? onTap}) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: AlbumItem(
          album: album,
          onTap: onTap,
        ),
      ),
    );
  }

  group('AlbumItem', () {
    testWidgets(
        'should display all album information when album type is present',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(album: tAlbumWithType));

      expect(find.text('Million Miles'), findsOneWidget);
      expect(find.text('Angelina Jordan'), findsOneWidget);
      expect(find.text('Single • 2020'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('should display only release date when album type is empty',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(album: tAlbumWithoutType));

      expect(find.text('Million Miles'), findsOneWidget);
      expect(find.text('Angelina Jordan'), findsOneWidget);
      expect(find.text('2020'), findsOneWidget);
      expect(find.text('Single • 2020'), findsNothing);
    });

    testWidgets('should show placeholder when image fails to load',
        (tester) async {
      final albumWithInvalidImage = tAlbumWithType.copyWith(
        images: [
          const spotify.Image(
            url: 'invalid_url',
            height: 300,
            width: 300,
          ),
        ],
      );

      await tester
          .pumpWidget(createWidgetUnderTest(album: albumWithInvalidImage));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.album), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          album: tAlbumWithType,
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(AlbumItem));
      expect(wasTapped, true);
    });

    testWidgets('should handle multiple artists', (tester) async {
      final albumWithMultipleArtists = tAlbumWithType.copyWith(
        artists: [
          const Artist(
            id: '1',
            name: 'Angelina Jordan',
            externalUrls: null,
            href: '',
            uri: '',
            popularity: 0,
            followers: null,
            genres: [],
            images: null,
          ),
          const Artist(
            id: '2',
            name: 'Big Mountain',
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

      await tester
          .pumpWidget(createWidgetUnderTest(album: albumWithMultipleArtists));

      expect(find.text('Angelina Jordan, Big Mountain'), findsOneWidget);
    });
  });
}
