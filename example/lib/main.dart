import 'package:android_plugin/android_plugin.dart';
import 'utils/colors_constants.dart';
import 'utils/numeric_constants.dart';
import 'package:flutter/cupertino.dart';
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
  bool _hasPermission = false;
  bool _isInitialized = false;
  bool _isStopped = false;

  @override
  void initState() {
    super.initState();
  }

  Future<bool> _checkPermission() async {
    bool _result = false;
    try {
      _result = await AndroidPlugin.permissionCheck;
    } on PlatformException {
      print(
        StringConstants.checkPermissionError,
      );
    }
    return _permissionGranted = _result;
  }

  Future<bool> _requestPermission() async {
    bool _result = false;
    try {
      _result = await AndroidPlugin.requestPermission;
    } on PlatformException {
      print(
        StringConstants.requestPermissionError,
      );
    }
    return _hasPermission = _result;
  }

  Future<void> getLocation() async {
    try {
      await AndroidPlugin.getLocation;
    } on PlatformException {
      print(
        StringConstants.locationError,
      );
    }
    return;
  }

  Future<bool> initialize() async {
    bool _initialize = false;
    try {
      _initialize = await AndroidPlugin.initialize;
    } on PlatformException {
      print(
        StringConstants.initializeError,
      );
    }
    return _isInitialized = _initialize;
  }

  Future<bool> stopLocation() async {
    bool _stopped = false;
    try {
      _stopped = await AndroidPlugin.stopLocationRequest;
    } on PlatformException {
      print(
        StringConstants.stopLocationError,
      );
    }
    return _isStopped = _stopped;
  }

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
                      Container(
                        margin: EdgeInsets.all(
                          NumericConstants.marginGestureDetector,
                        ),
                        height: NumericConstants.heightGestureDetector,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            NumericConstants.borderRadiusGestureDetector,
                          ),
                          color: ColorsConstants.gestureDetectorColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            _checkPermission();
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: NumericConstants
                                  .verticalPaddingCheckPermission,
                              horizontal: NumericConstants
                                  .horizontalPaddingCheckPermission,
                            ),
                            child: Text(
                              StringConstants.checkPermissionButton,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    NumericConstants.fontSizePermissionButton,
                              ),
                            ),
                          ),
                        ),
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
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _requestPermission();
                      });
                    },
                    child: Text(
                      StringConstants.requestPermissionButton,
                      style: TextStyle(
                        fontSize: NumericConstants.fontSizeButtonsText,
                        color: Colors.grey.shade300,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red.shade900,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.all(
                          NumericConstants.marginGestureDetector,
                        ),
                        height: NumericConstants.heightGestureDetector,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            NumericConstants.borderRadiusGestureDetector,
                          ),
                          color: ColorsConstants.gestureDetectorColor,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            initialize();
                            setState(() {});
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: NumericConstants
                                  .verticalPaddingCheckPermission,
                              horizontal: NumericConstants
                                  .horizontalPaddingCheckPermission,
                            ),
                            child: Text(
                              StringConstants.initializeButton,
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    NumericConstants.fontSizePermissionButton,
                              ),
                            ),
                          ),
                        ),
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
                      ElevatedButton(
                        onPressed: () {
                          _isStopped = false;
                          getLocation();
                        },
                        child: Text(
                          StringConstants.locationButton,
                          style: TextStyle(
                            fontSize: NumericConstants.fontSizeCoordinatesText,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade900,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          stopLocation();
                        },
                        child: Text(
                          StringConstants.stopLocationButton,
                          style: TextStyle(
                            fontSize: NumericConstants.fontSizeCoordinatesText,
                            color: Colors.grey.shade300,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red.shade900,
                        ),
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: AndroidPlugin.locationStream,
                    builder: (context, snapshot) {
                      return snapshot.hasData
                          ? Container(
                              padding: EdgeInsets.all(
                                NumericConstants.paddingCoordinates,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: !_isStopped
                                  ? Column(
                                      children: [
                                        Text(
                                          snapshot.data
                                              .toString()
                                              .split("%")
                                              .first,
                                          style: TextStyle(
                                            fontSize: NumericConstants
                                                .fontSizeLocationText,
                                          ),
                                        ),
                                        Text(
                                          snapshot.data
                                              .toString()
                                              .split("%")
                                              .last,
                                          style: TextStyle(
                                            fontSize: NumericConstants
                                                .fontSizeLocationText,
                                          ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      snapshot.data.toString(),
                                      style: TextStyle(
                                        fontSize: NumericConstants
                                            .fontSizeLocationText,
                                      ),
                                    ),
                            )
                          : Container(
                              padding: EdgeInsets.all(
                                NumericConstants.paddingCoordinates,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                ),
                              ),
                              child: Text(
                                StringConstants.locationNotFound,
                                style: TextStyle(
                                  fontSize:
                                      NumericConstants.fontSizeLocationText,
                                ),
                              ),
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
