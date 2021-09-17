import 'package:android_plugin_example/widgets/plugin_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const key = Key("pluginButtonKey");
  testWidgets("Testing of the correct implementation of the plugin button",
      (WidgetTester tester) async {
    var buttonIsWorking = false;
    final pluginButton = MaterialApp(
      home: Scaffold(
        body: PluginButton(
          key: key,
          onPressed: () {
            buttonIsWorking = true;
          },
          buttonText: "button test",
          fontSize: 20,
        ),
      ),
    );
    await tester.pumpWidget(pluginButton);
    var button = find.byKey(key);
    await tester.tap(button);
    await tester.pump();
    expect(find.byType(PluginButton), findsOneWidget);
    expect(buttonIsWorking, true);
  });
}
