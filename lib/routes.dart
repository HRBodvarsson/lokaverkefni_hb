import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'create_profile_screen.dart';
import 'main_menu_screen.dart';
import 'settings_screen.dart';
import 'user_profile_screen.dart';

class Routes {
  static const String login = '/login';
  static const String createProfile = '/createProfile';
  static const String mainMenu = '/mainMenu';
  static const String settings = '/settings';
  static const String userProfile = '/userProfile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.createProfile:
        return MaterialPageRoute(builder: (_) => const CreateProfileScreen());
      case Routes.mainMenu:
        return MaterialPageRoute(builder: (_) => const MainMenuScreen(profileData: {}));
      case Routes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case Routes.userProfile:
        return MaterialPageRoute(builder: (_) => const UserProfileScreen(profileData: {}));
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
