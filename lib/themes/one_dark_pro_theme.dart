import 'package:flutter/material.dart';

class OneDarkProTheme {
  static const Color background = Color(0xFF282C34);
  static const Color foreground = Color(0xFFABB2BF);
  static const Color black = Color(0xFF282C34);
  static const Color red = Color(0xFFE06C75);
  static const Color green = Color(0xFF98C379);
  static const Color yellow = Color(0xFFD19A66);
  static const Color blue = Color(0xFF61AFEF);
  static const Color magenta = Color(0xFFC678DD);
  static const Color cyan = Color(0xFF56B6C2);
  static const Color white = Color(0xFFABB2BF);

  static ThemeData themeData = ThemeData(
    brightness: Brightness.dark,
    primaryColor: background,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: blue,
      secondary: cyan,
      surface: background,
      error: red,
      onPrimary: white,
      onSecondary: black,
      onSurface: white,
      onError: white,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: white),
      displayMedium: TextStyle(color: white),
      displaySmall: TextStyle(color: white),
      headlineMedium: TextStyle(color: white),
      headlineSmall: TextStyle(color: white),
      titleLarge: TextStyle(color: white),
      titleMedium: TextStyle(color: white),
      titleSmall: TextStyle(color: white),
      bodyLarge: TextStyle(color: white),
      bodyMedium: TextStyle(color: white),
      bodySmall: TextStyle(color: white),
      labelLarge: TextStyle(color: white),
      labelSmall: TextStyle(color: white),
    ),
  );
}
