import 'package:flutter/material.dart';

class AppTheme {
  static const Color spotifyGreen = Color(0xFF1DB954);
  static const Color darkBackground = Color.fromARGB(255, 8, 8, 8);
  static const Color darkSurface = Color.fromARGB(255, 0, 0, 0);
  static const Color darkPrimaryText = Colors.white;
  static const Color darkSecondaryText = Colors.grey;

  static ThemeData get spotifyTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: spotifyGreen,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: spotifyGreen,
        surface: darkSurface,
        background: darkBackground,
        onPrimary: darkPrimaryText,
        onSurface: darkPrimaryText,
        secondary: spotifyGreen,
        onSecondary: darkPrimaryText,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBackground,
        titleTextStyle: TextStyle(
          color: darkPrimaryText,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: darkPrimaryText),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(color: darkPrimaryText),
        bodyLarge: TextStyle(color: darkPrimaryText),
        bodyMedium: TextStyle(color: darkSecondaryText),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: spotifyGreen,
        foregroundColor: darkPrimaryText,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: spotifyGreen,
          foregroundColor: darkPrimaryText,
        ),
      ),
      iconTheme: const IconThemeData(color: darkPrimaryText),
    );
  }
}
