import 'package:flutter/material.dart';

import 'welcome_screen.dart';
import 'create_profile_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

import 'ui/custom_navbar.dart';
import 'fonts.dart';
import 'styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snatalabb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          displayLarge: AppFonts.headline1,
          displayMedium: AppFonts.headline2,
          bodyLarge: AppFonts.bodyText1,
          bodyMedium: AppFonts.bodyText2,
          labelLarge: AppFonts.button,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: AppStyles.elevatedButtonStyle,
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  Map<String, dynamic> _profileData = {};

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      WelcomeScreen(navigateToCreateProfile: _navigateToCreateProfile),
      ProfileScreen(profileData: _profileData),
      const SettingsScreen(),
    ]);
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToCreateProfile(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
    );

    if (result != null) {
      setState(() {
        _profileData = result;
        _screens[1] = ProfileScreen(profileData: _profileData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: _currentIndex == 0
          ? null
          : CustomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTap,
            ),
    );
  }
}
