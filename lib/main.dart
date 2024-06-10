import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

//import 'database_helper.dart';
import 'routes.dart';
import 'styles/fonts.dart';
import 'styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get and print the database path
  final documentsDirectory = await getApplicationDocumentsDirectory();
  final path = join(documentsDirectory.path, "example.db");
  print("Database Path: $path");

  runApp(const MyApp());

  //await printDatabaseContents();
}

/* Future<void> printDatabaseContents() async {
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
} */

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
      initialRoute: Routes.login,
      onGenerateRoute: Routes.generateRoute,
    );
  }
}
