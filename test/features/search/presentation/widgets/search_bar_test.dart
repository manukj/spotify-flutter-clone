import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:spotify_flutter/features/search/presentation/widgets/search_bar.dart';

void main() {
  late TextEditingController defaultController;

  setUp(() {
    defaultController = TextEditingController();
  });

  tearDown(() {
    defaultController.dispose();
  });

  Widget createWidgetUnderTest({
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    String? hintText,
    VoidCallback? onClear,
  }) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: SpotifySearchBar(
          controller: controller ?? defaultController,
          onChanged: onChanged,
          hintText: hintText,
          onClear: onClear,
        ),
      ),
    );
  }

  group('SpotifySearchBar', () {
    testWidgets('should display search icon and hint text', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Artists, albums...'), findsOneWidget);
    });

    testWidgets('should display custom hint text when provided', (tester) async {
      await tester.pumpWidget(
        createWidgetUnderTest(hintText: 'Find artists'),
      );

      expect(find.text('Find artists'), findsOneWidget);
    });

    testWidgets('should show clear button when text is entered', (tester) async {
      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byIcon(Icons.clear), findsNothing);

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should clear text when clear button is tapped', (tester) async {
      defaultController.text = 'initial text';
      bool clearCalled = false;

      await tester.pumpWidget(
        createWidgetUnderTest(
          onClear: () => clearCalled = true,
        ),
      );

      await tester.tap(find.byIcon(Icons.clear));
      await tester.pump();

      expect(defaultController.text, isEmpty);
      expect(clearCalled, isTrue);
    });

    testWidgets('should call onChanged when text changes', (tester) async {
      String? changedText;
      await tester.pumpWidget(
        createWidgetUnderTest(
          onChanged: (value) => changedText = value,
        ),
      );

      await tester.enterText(find.byType(TextField), 'test input');
      expect(changedText, equals('test input'));
    });
  });
} 