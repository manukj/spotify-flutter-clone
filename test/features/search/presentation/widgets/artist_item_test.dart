import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_flutter/features/search/domain/entities/artist.dart';
import 'package:spotify_flutter/features/search/domain/entities/image.dart' as spotify;
import 'package:spotify_flutter/features/search/presentation/widgets/artist_item.dart';

void main() {
  final tArtistWithImage = Artist(
    id: '1',
    name: 'Angelina Jordan',
    externalUrls: null,
    href: '',
    uri: '',
    popularity: 0,
    followers: null,
    genres: [],
    images: [
      const spotify.Image(
        url: 'https://example.com/image.jpg',
        height: 300,
        width: 300,
      ),
    ],
  );

  final tArtistWithoutImage = Artist(
    id: '2',
    name: 'Angelina Jordan',
    externalUrls: null,
    href: '',
    uri: '',
    popularity: 0,
    followers: null,
    genres: [],
    images: null,
  );

  Widget createWidgetUnderTest({
    required Artist artist,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: ArtistItem(
          artist: artist,
          onTap: onTap,
        ),
      ),
    );
  }

  group('ArtistItem', () {
    testWidgets('should display artist name and image when image is available',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(artist: tArtistWithImage));

      expect(find.text('Angelina Jordan'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);
    });

    testWidgets(
        'should display artist name and placeholder when images list is null',
        (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(artist: tArtistWithoutImage));

      expect(find.text('Angelina Jordan'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);

      // Wait for image to fail loading
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should show placeholder when image fails to load',
        (tester) async {
      final artistWithInvalidImage = tArtistWithImage.copyWith(
        images: [
          const spotify.Image(
            url: 'invalid_url',
            height: 300,
            width: 300,
          ),
        ],
      );

      await tester.pumpWidget(
          createWidgetUnderTest(artist: artistWithInvalidImage));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should call onTap when tapped', (tester) async {
      bool wasTapped = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          artist: tArtistWithImage,
          onTap: () => wasTapped = true,
        ),
      );

      await tester.tap(find.byType(ArtistItem));
      expect(wasTapped, true);
    });

    testWidgets('should have correct dimensions and styling', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest(artist: tArtistWithImage));

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(ArtistItem),
          matching: find.byType(Container).first,
        ),
      );

      expect(container.constraints?.maxWidth, 56.0);
      expect(container.constraints?.maxHeight, 56.0);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);

      final text = tester.widget<Text>(find.text('Angelina Jordan'));
      expect(text.style?.color, Colors.white);
      expect(text.style?.fontWeight, FontWeight.w400);
    });
  });
} 