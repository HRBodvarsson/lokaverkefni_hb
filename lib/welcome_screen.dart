import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  final Function(BuildContext) navigateToCreateProfile;

  const WelcomeScreen({super.key, required this.navigateToCreateProfile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S N A T A L A B B !'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/vectors/snatalabb_logo_1.png'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => navigateToCreateProfile(context),
              child: const Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
