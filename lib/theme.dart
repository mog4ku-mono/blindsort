import 'package:flutter/material.dart';

import 'constants/app_spacing.dart';

/// BlindSort seed color. Material 3 generates the full ColorScheme from this
/// one value, so widgets reference semantic roles instead of picking colors
/// per screen.
const Color kSeedColor = Color(0xFF1565C0);

/// Teal used by the hero card, tabs, and section labels.
const Color kSecondaryTeal = Color(0xFF26A69A);

/// Darker teal used for folder icons so a folder reads differently from a
/// category tile at a glance.
const Color kFolderTeal = Color(0xFF00897B);

/// Light tint behind teal icons when a filled circle is not appropriate.
const Color kSecondaryContainer = Color(0xFFE0F2F1);

/// Dark teal used for icons and text that sit on the light tint.
const Color kOnSecondaryContainer = Color(0xFF00695C);

/// The application theme. Light mode only for the capstone.
final ThemeData appTheme = ThemeData(
  useMaterial3: true,
  colorScheme:
      ColorScheme.fromSeed(
        seedColor: kSeedColor,
        brightness: Brightness.light,
      ).copyWith(
        secondary: kSecondaryTeal,
        onSecondary: Colors.white,
        secondaryContainer: kSecondaryContainer,
        onSecondaryContainer: kOnSecondaryContainer,
      ),
  textTheme: const TextTheme(
    headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
  ),
  cardTheme: const CardThemeData(margin: EdgeInsets.all(AppSpacing.sm)),
);
