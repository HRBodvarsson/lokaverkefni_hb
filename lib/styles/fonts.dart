import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static TextStyle headline1 = GoogleFonts.lato(
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headline2 = GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static TextStyle headline3 = GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  static TextStyle bodyText1 = GoogleFonts.abhayaLibre(
    fontSize: 20,
    fontWeight: FontWeight.w400,
  );

  static TextStyle bodyText2 = GoogleFonts.abhayaLibre(
    fontSize: 18,
    fontWeight: FontWeight.w500,
  );

  static TextStyle button = GoogleFonts.lato(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: const Color.fromARGB(255, 255, 255, 255), // Default button text color
  );

}
