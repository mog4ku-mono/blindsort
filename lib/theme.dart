import 'package:flutter/material.dart';

import 'constants/app_spacing.dart';

/// BlindSort seed color. Material 3 generates the full ColorScheme from this
/// one value.
const Color kSeedColor = Color(0xFF1565C0);

/// Teal used by the hero card, tabs, and section labels.
const Color kSecondaryTeal = Color(0xFF26A69A);

/// Darker teal used for section headers and folder icons.
const Color kFolderTeal = Color(0xFF00897B);

/// Light tint behind teal icons.
const Color kSecondaryContainer = Color(0xFFE0F2F1);

/// Dark teal used for icons and text on the light tint.
const Color kOnSecondaryContainer = Color(0xFF00695C);

const TextTheme _sharedTextTheme = TextTheme(
  headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  bodyMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
  labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
);

/// Light theme. Default for the capstone.
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
  textTheme: _sharedTextTheme,
  cardTheme: const CardThemeData(margin: EdgeInsets.all(AppSpacing.sm)),
);

/// Dark theme. Same layout and accent teal, only the surfaces flip.
final ThemeData darkAppTheme = ThemeData(
  useMaterial3: true,
  colorScheme:
      ColorScheme.fromSeed(
        seedColor: kSeedColor,
        brightness: Brightness.dark,
      ).copyWith(
        secondary: kSecondaryTeal,
        onSecondary: Colors.black,
        secondaryContainer: const Color(0xFF1B4F4A),
        onSecondaryContainer: const Color(0xFF80CBC4),
      ),
  textTheme: _sharedTextTheme,
  cardTheme: const CardThemeData(margin: EdgeInsets.all(AppSpacing.sm)),
);
