import 'package:flutter/material.dart';

import 'constants/app_spacing.dart';

/// The BlindSort seed color. Material 3 generates the full ColorScheme from
/// this one value, so widget code references semantic roles (primary, surface,
/// onSurface) instead of picking colors per screen.
const Color kSeedColor = Color(0xFF1565C0);

/// The application theme. Three text roles cover the four approved screens:
/// heading, body, caption. Kept to light mode for the capstone; widgets still
/// read through Theme.of(context) so a future dark scheme needs no rewrite.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: kSeedColor,
    brightness: Brightness.light,
  ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
  ),
  cardTheme: const CardThemeData(margin: EdgeInsets.all(AppSpacing.sm)),
);
