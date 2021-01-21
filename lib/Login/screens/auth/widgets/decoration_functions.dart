import 'package:Bealthy_app/Login/config/palette.dart';
import 'package:flutter/material.dart';

InputDecoration registerInputDecoration({String hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
    hintText: hintText,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.secondaryLight, width: 2),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.errorLight),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Palette.errorLight),
    ),
    errorStyle: const TextStyle(color: Palette.errorLight, fontSize: 14),
  );
}

InputDecoration signInInputDecoration({String hintText}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 18.0),
    hintStyle: const TextStyle(fontSize: 18, color: Colors.black),
    hintText: hintText,
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2, color: Palette.secondaryLight),
    ),
    enabledBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.darkBlue),
    ),
    errorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Palette.errorDark),
    ),
    focusedErrorBorder: const UnderlineInputBorder(
      borderSide: BorderSide(width: 2.0, color: Palette.errorDark),
    ),
    errorStyle: const TextStyle(color: Palette.errorDark, fontSize: 14),
  );
}
