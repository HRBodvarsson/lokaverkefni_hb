import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import 'login_screen.dart';
import 'create_profile_screen.dart';
import 'user_profile_screen.dart';
import 'settings_screen.dart';
import 'main_menu_screen.dart';

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
      home: LoginScreen(
        navigateToCreateProfile: (context) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateProfileScreen()),
          );
        },
        navigateToMainMenu: (context) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainMenuScreen(profileData: {},)),
          );
        },
      ),
    );
  }
}
