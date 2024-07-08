import 'theme_interface.dart';
import 'package:flutter/material.dart';

class OneDarkProTheme implements ThemeInterface {
  @override
  Color get background => const Color(0xFF282C34);
  @override
  Color get foreground => const Color(0xFFABB2BF);
  @override
  Color get black => const Color(0xFF282C34);
  @override
  Color get red => const Color(0xFFE06C75);
  @override
  Color get green => const Color(0xFF98C379);
  @override
  Color get yellow => const Color(0xFFD19A66);
  @override
  Color get blue => const Color(0xFF61AFEF);
  @override
  Color get magenta => const Color(0xFFC678DD);
  @override
  Color get cyan => const Color(0xFF56B6C2);
  @override
  Color get white => const Color(0xFFABB2BF);

  @override
  ThemeData get themeData => ThemeData(
        brightness: Brightness.dark,
        primaryColor: background,
        scaffoldBackgroundColor: background,
        colorScheme: ColorScheme.dark(
          primary: blue,
          secondary: cyan,
          surface: background,
          error: red,
          onPrimary: white,
          onSecondary: black,
          onSurface: white,
          onError: white,
        ),
        textTheme: TextTheme(
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
