import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Palette {
  static const Color darkBlue = Color(0xff1f9aad); //ora è il ligh
  static const Color lightBlue = Color(0xff13606c); //questo è il dark
  static const Color orange = Color(0xffFFA62B);
  static const Color darkOrange = Color(0xffCC7700);
  static const Color appBarColor = Color(0xddcc3a00);

  static const Color primaryDark = Color(0xff005f64);
  static const Color primaryLight = Color(0xff01abc1);
  static const Color primaryMoreLight = Color(0xff4dcfe1);
  static const Color primaryDoubleMoreLight = Color(0xffb2ebf2);
  static const Color primaryThreeMoreLight = Color(0xffe0f7fa);


  static const Color secondaryDark = Color(0xffd84701);
  static const Color secondaryLight = Color(0xffe26200);
  static const Color secondaryMoreLight = Color(0xfff6ae4a);
  static const Color secondaryDoubleMoreLight = Color(0xfffcdcb0);
  static const Color secondaryThreeMoreLight = Color(0xfffef1df);

  static const Color highLightColor = Color(0xffffcc99);
  static const Color highLightColor2 = Color(0xffb2ebf2);

  static const Color errorDark = Color(0xffB00020);
  static const Color errorLight = Color(0xffFF8A80);

  static const ColorScheme bealthyColorScheme = ColorScheme(
    primary:Color(0xff0096a7),
    primaryVariant: Color(0xff006878),
    onPrimary: Color(0xffFFFFFF),
    secondary: Color(0xffe26200),
    secondaryVariant: Color(0xffa93200),
    onSecondary: Color(0xffFFFFFF),
    background:Color(0xfff5f5f5),
    onBackground:Color(0xff000000),
    surface: Color(0xffffffff),
    onSurface:Color(0xff000000),
    error:Color(0xffB00020),
    onError:Color(0xffFFFFFF),
    brightness:Brightness.light,
  );
}