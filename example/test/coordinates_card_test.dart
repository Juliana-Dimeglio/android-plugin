import 'package:android_plugin_example/widgets/coordinates_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Testing of the coordinates card", () {
    testWidgets("Testing if the hasData is working with the location active",
        (WidgetTester tester) async {
      final coordinatesCard = MaterialApp(
        home: Scaffold(
          body: CoordinatesCard(
            data: "Coordinates test",
            hasData: true,
            isStopped: false,
          ),
        ),
      );
      await tester.pumpWidget(coordinatesCard);
      var card = find.byType(CoordinatesCard);
      expect(card, findsOneWidget);
      expect(find.text("Coordinates test"), findsWidgets);
    });

    testWidgets("Testing if the hasData is working with the location stopped",
        (WidgetTester tester) async {
      final coordinatesCard = MaterialApp(
        home: Scaffold(
          body: CoordinatesCard(
            data: "Coordinates location stopped",
            hasData: true,
            isStopped: true,
          ),
        ),
      );
      await tester.pumpWidget(coordinatesCard);
      var card = find.byType(CoordinatesCard);
      expect(card, findsOneWidget);
      expect(find.text("Coordinates location stopped"), findsOneWidget);
    });

    testWidgets("Testing if the hasData is false", (WidgetTester tester) async {
      final coordinatesCard = MaterialApp(
        home: Scaffold(
          body: CoordinatesCard(
            data: null,
            hasData: false,
            isStopped: true,
          ),
        ),
      );
      await tester.pumpWidget(coordinatesCard);
      var card = find.byType(CoordinatesCard);
      expect(card, findsOneWidget);
      expect(find.text("Location not found"), findsOneWidget);
    });
  });
}
