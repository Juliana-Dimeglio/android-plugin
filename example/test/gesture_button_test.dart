import 'package:android_plugin_example/widgets/gesture_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const key = Key("gestureButtonKey");
  testWidgets("Testing of the correct implementation of the gesture detector",
          (WidgetTester tester) async {
        var buttonIsWorking = false;
        final gestureButton = MaterialApp(
          home: Scaffold(
            body: GestureButton(
              key: key,
              onTap: () {
                buttonIsWorking = true;
              },
              buttonText: "button test",
            ),
          ),
        );
        await tester.pumpWidget(gestureButton);
        var button = find.byKey(key);
        await tester.tap(button);
        await tester.pump();
        expect(find.byType(GestureButton), findsOneWidget);
        expect(buttonIsWorking, true);
      });
}
