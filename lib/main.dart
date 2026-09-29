import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

import 'data/sample_files.dart';
import 'screens/home_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';

void main() {
  AppState.init(sampleFiles);
  runApp(
    DevicePreview(
      // Frame the app in a phone shell only on web. On a real device the
      // frame would sit inside the actual phone screen, so it is off.
      enabled: kIsWeb,
      builder: (context) => const BlindSortApp(),
    ),
  );
}

class BlindSortApp extends StatelessWidget {
  const BlindSortApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppState.themeMode,
      builder: (context, mode, _) => MaterialApp(
        title: 'BlindSort',
        debugShowCheckedModeBanner: false,
        // DevicePreview.locale and DevicePreview.appBuilder only make sense
        // when the preview wrapper is active. On device they are skipped.
        locale: kIsWeb ? DevicePreview.locale(context) : null,
        builder: kIsWeb ? DevicePreview.appBuilder : null,
        theme: appTheme,
        darkTheme: darkAppTheme,
        themeMode: mode,
        themeAnimationDuration: const Duration(milliseconds: 350),
        themeAnimationCurve: Curves.easeInOut,
        home: const HomeScreen(),
      ),
    );
  }
}
