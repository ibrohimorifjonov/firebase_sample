import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_style.dart';

final ThemeData appThemeData = ThemeData(
  primaryColor: clrWhite,
  accentColor: clrWhite,
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: clrWhite,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: clrWhite,
      statusBarIconBrightness: Brightness.dark,
    ),
  ),
  backgroundColor: clrWhite,
  fontFamily: gilroy,
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  ),
);
