import 'package:android_plugin/android_plugin.dart';
import '../utils/string_constants.dart';
import 'package:flutter/services.dart';

class PluginFunctionality {
  Future<bool> checkPermission() async {
    bool _result = false;
    try {
      _result = await AndroidPlugin.permissionCheck;
    } on PlatformException {
      print(
        StringConstants.checkPermissionError,
      );
    }
    return _result;
  }

  Future<bool> requestPermission() async {
    bool _result = false;
    try {
      _result = await AndroidPlugin.requestPermission;
    } on PlatformException {
      print(
        StringConstants.requestPermissionError,
      );
    }
    return _result;
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
    return _initialize;
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
    return _stopped;
  }
}
