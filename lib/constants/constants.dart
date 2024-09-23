// ignore_for_file: constant_identifier_names

import 'package:dtt_assessment/constants/custom_colors.dart';
import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:flutter/material.dart';

class Constants {
  static const BASEURL = "https://intern.d-tt.nl";

  // Instead of writing all this everytime, its easier to just say Constants.push
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: TextStyles.fontFamily,
    scaffoldBackgroundColor: CustomColors.lightGray,
    appBarTheme: const AppBarTheme(
        backgroundColor: CustomColors.lightGray, scrolledUnderElevation: 0),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Colors.black,
      onPrimary: Colors.white,
      secondary: Colors.black,
      onSecondary: Colors.black,
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: TextStyles.fontFamily,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black, scrolledUnderElevation: 0),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.white,
      onPrimary: Colors.black,
      secondary: Colors.white,
      onSecondary: Colors.white,
      error: Colors.red,
      onError: Colors.black,
      surface: Colors.black,
      onSurface: Colors.white,
    ),
  );
}
