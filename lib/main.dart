import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'welcome_screen.dart';
import 'create_profile_screen.dart';
import 'user_profile_screen.dart';
import 'settings_screen.dart';

import 'ui/custom_navbar.dart';
import 'styles/fonts.dart';
import 'styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get and print the database path
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join(documentsDirectory.path, "example.db");
  print("Database Path: $path");

  runApp(const MyApp());

  // Print database contents for debugging
  await printDatabaseContents();
}

Future<void> printDatabaseContents() async {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> profiles = await dbHelper.queryAllProfiles();
  List<Map<String, dynamic>> bookings = await dbHelper.queryAllBookings();

  print("Profiles Table:");
  for (var row in profiles) {
    print(row);
  }

  print("Bookings Table:");
  for (var row in bookings) {
    print(row);
  }
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
          displaySmall: AppFonts.headline3,
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
  final dbHelper = DatabaseHelper.instance;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _screens.addAll([
      WelcomeScreen(navigateToCreateProfile: _navigateToCreateProfile),
      ProfileScreen(profileData: _profileData),
      const SettingsScreen(),
    ]);
    _loadProfileData();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
      // Load profile data if Profile tab is selected
      if (index == 1) {
        _loadProfileData();
      }
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
      _saveProfileData(result);
    }
  }

  void _saveProfileData(Map<String, dynamic> data) async {
    await dbHelper.insertProfile(data);
    // Print database contents for debugging
    await printDatabaseContents();
  }

  void _loadProfileData() async {
    final allRows = await dbHelper.queryAllProfiles();
    if (allRows.isNotEmpty) {
      setState(() {
        _profileData = allRows.first;
        _screens[1] = ProfileScreen(profileData: _profileData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Screen'),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
