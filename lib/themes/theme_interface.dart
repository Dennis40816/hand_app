import 'package:flutter/material.dart';

abstract class ThemeInterface {
  Color get background;
  Color get foreground;
  Color get black;
  Color get red;
  Color get green;
  Color get yellow;
  Color get blue;
  Color get magenta;
  Color get cyan;
  Color get white;
  ThemeData get themeData;
}
