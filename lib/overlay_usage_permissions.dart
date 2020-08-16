import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class OverlayUsagePermissions {

  static const MethodChannel _channel =
      const MethodChannel('overlay_usage_permissions');

  static Future<bool> get usageStatsGranted async {
    if (!Platform.isAndroid) return false;
    return await _channel.invokeMethod("isStatsGranted");
  }

  static Future<bool> get drawGranted async {
    if (!Platform.isAndroid) return false;
    return await _channel.invokeMethod("isDrawGranted");
  }

  static requestUsageStats() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod("requestStats");
  }

  static requestDraw() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod("requestDraw");
  }

}
