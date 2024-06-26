import 'package:flutter/material.dart';

class TextFieldStyle {
  // Border design when the textfield is not in focus.
  static const loginfield = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide(
      color: Colors.black,
      width: 2.0,
    ),
  );

  // Border design when the textfield is in focus.
  static const focussedLoginField = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10),
    ),
    borderSide: BorderSide(
      color: Colors.black,
      width: 2.5,
    ),
  );

   static const SearchLocationField = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(25),
    ),
    borderSide: BorderSide(
      color: Colors.white,
      width: 0.0,
    ),
  );
}
