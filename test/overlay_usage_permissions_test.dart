import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:overlay_usage_permissions/overlay_usage_permissions.dart';

void main() {
  const MethodChannel channel = MethodChannel('overlay_usage_permissions');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  group("Tests", () {
    // Can't mock platform(to Android), won't even make it past the first conditional
    test('usageStatsGranted', () async {
      expect(await OverlayUsagePermissions.usageStatsGranted, false);
    });

    // Can't mock platform(to Android), won't even make it past the first conditional
    test('drawGranted', () async {
      expect(await OverlayUsagePermissions.drawGranted, false);
    });
  });

}
