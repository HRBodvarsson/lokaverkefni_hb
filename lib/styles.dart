import 'package:flutter/material.dart';
import 'fonts.dart'; // Import fonts.dart to use defined text styles

class AppStyles {
  static final ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 45, 39, 39), // Button background color
    foregroundColor: const Color.fromARGB(255, 178, 239, 247), // Text color
    textStyle: AppFonts.button, // Use the text style defined in fonts.dart
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    side: const BorderSide(color: Colors.black), // Add border if needed
  );
}
