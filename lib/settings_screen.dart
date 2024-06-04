import 'package:flutter/material.dart';
import 'utility.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _eraseProfileData(BuildContext context) async {
    await eraseProfileData();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('User profile data erased')),
    );
  }

  void _quitApplication() {
    quitApplication();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _eraseProfileData(context),
              child: const Text('Erase Profile Data'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _quitApplication,
              child: const Text('Quit Application'),
            ),
          ],
        ),
      ),
    );
  }
}
