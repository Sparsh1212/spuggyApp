import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'decider.dart';
import 'package:device_preview/device_preview.dart';

void main() => runApp(DevicePreview(
      // Ensures that it is disabled in release mode
      builder: (context) => MyApp(),
    ));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: DevicePreview.of(context).locale, // <--- Add the locale
      builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: Decider(),
    );
  }
}
