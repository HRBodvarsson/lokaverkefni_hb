import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'login_screen.dart';
import 'create_profile_screen.dart';
import 'user_profile_screen.dart';
import 'settings_screen.dart';
import 'main_menu_screen.dart';// Import CLI functions

import 'ui/custom_navbar.dart';
import 'styles/fonts.dart';
import 'styles/styles.dart';

var kColorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 96, 59, 181),
);

var kDarkColorScheme = ColorScheme.fromSeed(
  brightness: Brightness.dark,
  seedColor: const Color.fromARGB(255, 5, 99, 125),
);


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get and print the database path
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join(documentsDirectory.path, "example.db");
  print("Database Path: $path");

  // Check if a profile exists
  final dbHelper = DatabaseHelper.instance;
  final allProfiles = await dbHelper.queryAllProfiles();
  final bool hasProfile = allProfiles.isNotEmpty;

  runApp(MyApp(hasProfile: hasProfile));

  // Print database contents for debugging
  await printDatabaseContents();

}

Future<void> printDatabaseContents() async {
  final dbHelper = DatabaseHelper.instance;
  List<Map<String, dynamic>> profiles = await dbHelper.queryAllProfiles();
  List<Map<String, dynamic>> bookings = await dbHelper.queryAllBookings();
}

class MyApp extends StatelessWidget {

  const MyApp({super.key, required this.hasProfile});

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
      home: hasProfile ? const LoginScreen() : LoginScreen(navigateToCreateProfile: (context) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
        );
      }),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required Null Function(dynamic context) navigateToCreateProfile});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  int _currentIndex = 0;
  Map<String, dynamic> _profileData = {};
  final dbHelper = DatabaseHelper.instance;

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void z(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
    );

    if (result != null) {
      setState(() {
        _profileData = result;
      });
      _saveProfileData(result);
    }
  }

  void _saveProfileData(Map<String, dynamic> data) async {
    await dbHelper.insertProfile(data);
    await printDatabaseContents(); // For debugging
  }

  void _loadProfileData() async {
    final allRows = await dbHelper.queryAllProfiles();
    if (allRows.isNotEmpty) {
      setState(() {
        _profileData = allRows.first;
      });
      _screens.addAll([
        MainMenuScreen(profileData: _profileData),
        ProfileScreen(profileData: _profileData),
        const SettingsScreen(),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_screens.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
