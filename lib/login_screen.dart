import 'package:flutter/material.dart';
import 'styles/styles.dart';
import 'styles/fonts.dart'; // Import the styles
import 'routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController(text: 'dummyuser');
    final TextEditingController passwordController = TextEditingController(text: 'dummypassword');

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
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add login logic here
                Navigator.pushReplacementNamed(context, Routes.mainMenu);
              },
              style: AppStyles.elevatedButtonStyle, // Use the custom style
              child: Text(
                'Login',
                style: AppFonts.button,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, Routes.createProfile);
              },
              style: AppStyles.elevatedButtonStyle, // Use the custom style
              child: Text(
                'Create New Profile',
                style: AppFonts.button,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
