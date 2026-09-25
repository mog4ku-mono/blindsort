import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

import 'data/sample_files.dart';
import 'screens/home_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';

void main() {
  AppState.init(sampleFiles);
  runApp(
    DevicePreview(enabled: true, builder: (context) => const BlindSortApp()),
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
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        theme: appTheme,
        darkTheme: darkAppTheme,
        themeMode: mode,
        home: const HomeScreen(),
      ),
    );
  }
}
