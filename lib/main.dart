import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme.dart';
import 'screens/file_browser_screen.dart';

void main() {
  runApp(
    // device_preview keeps the browser demo at phone size. Stays on in the
    // deployed build so the live link opens framed instead of stretched.
    DevicePreview(enabled: true, builder: (context) => const BlindSortApp()),
  );
}

class BlindSortApp extends StatelessWidget {
  const BlindSortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BlindSort',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: appTheme,
      home: const FileBrowserScreen(),
    );
  }
}
