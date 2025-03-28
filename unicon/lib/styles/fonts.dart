import 'package:flutter/material.dart';

import 'colors.dart';

class AppFonts {
  static const String arial = 'Arial';
  static const String arialblk = 'ArialBlack';
  static const String SansSerifCollection = 'SansSerifCollection';


  static const TextStyle headline = TextStyle(
    fontFamily: arial,
    fontSize: 20,
    color: Colors.white,
  );
  static const TextStyle caption = TextStyle(
    fontFamily: arialblk,
    fontSize: 16,
    color: Colors.black,
  );
  static const TextStyle comment = TextStyle(
    fontFamily: SansSerifCollection,
    fontSize: 14,
    color: AppColors.primaryBlue,
  );
}
