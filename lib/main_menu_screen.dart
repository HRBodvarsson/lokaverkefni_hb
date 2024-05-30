import 'package:flutter/material.dart';
import 'ui/custom_navbar.dart';
import 'welcome_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const MainMenuScreen({super.key, required this.profileData});

  @override
  MainMenuScreenState createState() => MainMenuScreenState();
}

class MainMenuScreenState extends State<MainMenuScreen> {
  int _currentIndex = 0;

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Map has been removed"),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
