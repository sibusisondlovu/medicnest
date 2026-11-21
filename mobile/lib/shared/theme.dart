import 'package:flutter/material.dart';

/// Calm, clinical palette: deep teal primary, amber reserved for flags.
const Color medicnestTeal = Color(0xFF0F6E6E);
const Color flagAmber = Color(0xFFB7791F);

ThemeData buildMedicnestTheme() {
  final scheme = ColorScheme.fromSeed(seedColor: medicnestTeal);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    // Large, readable text for patients.
    textTheme: Typography.blackMountainView.apply(fontSizeFactor: 1.1),
    cardTheme: const CardThemeData(margin: EdgeInsets.zero),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(56),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    ),
  );
}
