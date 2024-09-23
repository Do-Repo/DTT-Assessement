import 'package:flutter/material.dart';

class TextStyles {
  static const fontFamily = "Gotham SSm";

  static TextStyle header_01 = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 20);
  static TextStyle header_02 = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w700, fontSize: 16);
  static TextStyle header_03 = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w500, fontSize: 16);
  static TextStyle body = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 12);
  static TextStyle input = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 15);
  static TextStyle subtitle = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 10);

  // Weird how these are the same...
  static TextStyle hint = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w300, fontSize: 15);
  static TextStyle detail = const TextStyle(
      fontFamily: fontFamily, fontWeight: FontWeight.w400, fontSize: 10);
}
