import 'package:android_plugin/android_plugin.dart';
import 'utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _permissionGranted = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> checkPermission() async {
    bool result = false;
    try {
      result = await AndroidPlugin.permissionCheck;
    } on PlatformException {
      print(
        StringConstants.checkPermissionError,
      );
    }
    return _permissionGranted = !result;
  }

  Future<void> requestPermission() async {
    try {
      await AndroidPlugin.requestPermission;
    } on PlatformException {
      print(
        StringConstants.requestPermissionError,
      );
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            StringConstants.titleAppBar,
          ),
        ),
        body: Column(
          children: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    checkPermission();
                  });
                },
                child: Text(
                  StringConstants.checkPermissionButton,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                requestPermission();
              },
              child: Text(
                StringConstants.requestPermissionButton,
              ),
            ),
            Text(
              _permissionGranted
                  ? StringConstants.permissionApproved
                  : StringConstants.permissionDenied,
            ),
          ],
        ),
      ),
    );
  }
}
