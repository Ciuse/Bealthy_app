import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class Palette {
  static const Color darkBlue = Color(0xff1f9aad); //ora è il ligh
  static const Color lightBlue = Color(0xff13606c); //questo è il dark
  static const Color orange = Color(0xffFFA62B);
  static const Color darkOrange = Color(0xffCC7700);
  static const Color appBarColor = Color(0xddcc3a00);
  static const Color primaryDark = Color(0xff7e3f1b);
  static const Color primaryLight = Color(0xffd2692d);
  static const Color primaryMoreLight = Color(0xffdb8757);
  static const Color primaryDoubleMoreLight = Color(0xffe9b496);
  static const Color primaryThreeMoreLight = Color(0xfff6e1d5);


  static const Color secondaryDark = Color(0xff2e004d);
  static const Color secondaryLight = Color(0xffad33ff);
  static const Color secondaryThreeMoreLight = Color(0xffcfccff);

  static const Color tealDark2 = Color(0xff2e846f);
  static const Color tealLight2 = Color(0xff3caa8e);
  static const Color tealMoreLight2 = Color(0xff55c3a8);
  static const Color tealDoubleMoreLight2 = Color(0xff6ccbb3);
  static const Color tealThreeMoreLight2 = Color(0xff8ed7c5);

  static const ColorScheme bealthyColorScheme = ColorScheme(
    primary:Color(0xff0096a7),
    primaryVariant: Color(0xff005f64),
    onPrimary: Color(0xffFFFFFF),
    secondary: Color(0xffe26200),
    secondaryVariant: Color(0xffaf3d00),
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