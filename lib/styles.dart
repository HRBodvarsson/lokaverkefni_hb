import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppStyles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 45, 39, 39), // Button background color
    foregroundColor: const Color.fromARGB(255, 178, 239, 247), // Text color
    textStyle: GoogleFonts.lato(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: const BorderSide(color: Colors.black), // Add border if needed
  );
}
