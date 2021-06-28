import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:overlay_usage_permissions/overlay_usage_permissions.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _usageStatsGranted = false;
  bool _drawOverlaysGranted = false;

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPermissions() async {
    bool usageStatsGranted = false;
    bool drawOverlaysGranted = false;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      usageStatsGranted = await OverlayUsagePermissions.usageStatsGranted;
      drawOverlaysGranted = await OverlayUsagePermissions.drawGranted;
    } on PlatformException {
      usageStatsGranted = false;
      drawOverlaysGranted = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _usageStatsGranted = usageStatsGranted;
      _drawOverlaysGranted = drawOverlaysGranted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Usage Stats Granted: $_usageStatsGranted'),
              Text('Draw Overlays Granted: $_drawOverlaysGranted'),
              ElevatedButton(
                child: Text('Grant Usage Stats'),
                onPressed: () async {
                  await OverlayUsagePermissions.requestUsageStats();
                  await initPermissions();
                },
              ),
              ElevatedButton(
                child: Text('Grant Draw Overlays'),
                onPressed: () async {
                  await OverlayUsagePermissions.requestDraw();
                  await initPermissions();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
