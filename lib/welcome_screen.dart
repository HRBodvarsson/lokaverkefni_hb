import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'styles.dart'; // Import the styles

class WelcomeScreen extends StatelessWidget {
  final Function(BuildContext) navigateToCreateProfile;

  const WelcomeScreen({super.key, required this.navigateToCreateProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: null,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // Center elements horizontally
          children: [
            Text(
              'Welcome to',
              style: GoogleFonts.lato(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: 150,
              height: 150,
              child: Image.asset('assets/vectors/snatalabb_logo_1.png'),
            ),
            const SizedBox(height: 10),
            const Text(
              'S N A T A L A B B !',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(), // This will push the button to the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0), // Add padding if needed
              child: ElevatedButton(
                onPressed: () => navigateToCreateProfile(context),
                style: AppStyles.elevatedButtonStyle, // Use the custom style
                child: const Text('Create Profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
