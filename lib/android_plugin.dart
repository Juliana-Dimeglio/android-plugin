import 'dart:async';

import 'utils/string_constants.dart';
import 'package:flutter/services.dart';

class AndroidPlugin {
  static const MethodChannel _channel =
      const MethodChannel(StringConstants.channel);

  static Future<bool> get permissionCheck async =>
      await _channel.invokeMethod(StringConstants.methodPermissionCheck);

  static Future<void> get requestPermission async {
    await _channel.invokeMethod(StringConstants.methodPermissionRequest);
    return;
  }
}
