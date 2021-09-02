import 'dart:async';

import 'utils/string_constants.dart';
import 'package:flutter/services.dart';

class AndroidPlugin {
  static const MethodChannel _channel =
      const MethodChannel(StringConstants.channel);

  static const EventChannel _eventChannelLocation =
      EventChannel(StringConstants.locationChannel);

  static Stream<dynamic> locationStream =
      _eventChannelLocation.receiveBroadcastStream();

  static Future<bool> get permissionCheck async =>
      await _channel.invokeMethod(StringConstants.methodPermissionCheck);

  static Future<bool> get requestPermission async {
    return await _channel.invokeMethod(StringConstants.methodPermissionRequest);
  }

  static Future<bool> get getLocation async {
    return await _channel.invokeMethod(StringConstants.getLocation);
  }

  static Future<bool> get initialize async {
    return await _channel.invokeMethod(StringConstants.initialize);
  }

  static Future<bool> get stopLocationRequest async {
    return await _channel.invokeMethod(StringConstants.stopLocationRequest);
  }
}
