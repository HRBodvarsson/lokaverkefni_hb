import 'package:flutter/material.dart';
import 'styles.dart';
import 'fonts.dart'; // Import the styles

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
          crossAxisAlignment:
              CrossAxisAlignment.center, // Center elements horizontally
          children: [
            Text(
              'Welcome to',
              style: AppFonts.headline2,
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: 150,
              height: 150,
              child: Image.asset('assets/vectors/snatalabb_logo_1.png'),
            ),
            const SizedBox(height: 10),
            Text(
              'S N A T A L A B B !',
              style: AppFonts.headline1,
            ),
            const Spacer(), // This will push the button to the bottom
            Padding(
              padding:
                  const EdgeInsets.only(bottom: 40.0), // Add padding if needed
              child: ElevatedButton(
                onPressed: () => navigateToCreateProfile(context),
                style: AppStyles.elevatedButtonStyle, // Use the custom style
                child: Text(
                  'Create Profile',
                  style: AppFonts.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
