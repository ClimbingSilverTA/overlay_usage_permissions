import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';

class OverlayUsagePermissions {
  static const MethodChannel _channel =
      const MethodChannel('overlay_usage_permissions');

  static Future<bool> get usageStatsGranted async {
    if (!Platform.isAndroid) return false;
    return await _channel.invokeMethod("isStatsGranted") ?? false;
  }

  static Future<bool> get drawGranted async {
    if (!Platform.isAndroid) return false;
    return await _channel.invokeMethod("isDrawGranted") ?? false;
  }

  static Future<void> requestUsageStats() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod("requestStats");
  }

  static Future<void> requestDraw() async {
    if (!Platform.isAndroid) return;
    await _channel.invokeMethod("requestDraw");
  }
}
