import 'package:android_plugin/android_plugin.dart';
import 'widgets/coordinates_card.dart';
import 'widgets/plugin_button.dart';
import 'features/plugin_functionality.dart';
import 'utils/colors_constants.dart';
import 'utils/numeric_constants.dart';
import 'package:flutter/cupertino.dart';
import 'utils/string_constants.dart';
import 'package:flutter/material.dart';
import 'widgets/gesture_button.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _permissionGranted = false;
  bool _hasPermission = false;
  bool _isInitialized = false;
  bool _isStopped = false;

  PluginFunctionality _pluginFunctionality = PluginFunctionality();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkPermission() async =>
      _permissionGranted = await _pluginFunctionality.checkPermission();

  Future<void> _initialize() async =>
      _isInitialized = await _pluginFunctionality.initialize();

  Future<void> _requestPermission() async =>
      _hasPermission = await _pluginFunctionality.requestPermission();

  Future<void> _getLocation() async {
    _isStopped = false;
    return await _pluginFunctionality.getLocation();
  }

  Future<void> _stopLocationRequest() async =>
      _isStopped = await _pluginFunctionality.stopLocation();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorsConstants.appBarBackground,
          title: const Text(
            StringConstants.titleAppBar,
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: ColorsConstants.bodyBackgroundColor,
          ),
          child: Center(
            child: Container(
              margin: EdgeInsets.only(
                top: NumericConstants.marginTop,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureButton(
                        buttonText: StringConstants.checkPermissionButton,
                        onTap: () => setState(() {
                          _checkPermission();
                        }),
                      ),
                      Text(
                        _permissionGranted && _hasPermission
                            ? StringConstants.permissionApproved
                            : StringConstants.permissionDenied,
                        style: TextStyle(
                          fontSize: NumericConstants
                              .fontSizePermission_InitializeText,
                        ),
                      ),
                    ],
                  ),
                  PluginButton(
                    onPressed: _requestPermission,
                    buttonText: StringConstants.requestPermissionButton,
                    fontSize: NumericConstants.fontSizePermissionButton,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureButton(
                        onTap: () => setState(() {
                          _initialize();
                        }),
                        buttonText: StringConstants.initializeButton,
                      ),
                      Text(
                        _isInitialized
                            ? StringConstants.initializeText
                            : StringConstants.notInitializeText,
                        style: TextStyle(
                          fontSize: NumericConstants
                              .fontSizePermission_InitializeText,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      PluginButton(
                        onPressed: _getLocation,
                        buttonText: StringConstants.locationButton,
                        fontSize: NumericConstants.fontSizeCoordinatesText,
                      ),
                      PluginButton(
                        onPressed: _stopLocationRequest,
                        buttonText: StringConstants.stopLocationButton,
                        fontSize: NumericConstants.fontSizeCoordinatesText,
                      )
                    ],
                  ),
                  StreamBuilder(
                    stream: AndroidPlugin.locationStream,
                    builder: (context, snapshot) {
                      return CoordinatesCard(
                        data: snapshot.data,
                        hasData: snapshot.hasData,
                        isStopped: _isStopped,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
