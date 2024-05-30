import 'package:flutter/material.dart';
import 'ui/custom_navbar.dart';
import 'list_of_walkers.dart';

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

  void _navigateToWalkers(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListOfWalkers()),
    );
  }

  void _bookWalk() {
    _navigateToWalkers(context);
  }

  void _bookSitter() {
    // Implement the functionality for booking a sitter
    print("Book a sitter pressed");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Main Menu"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _bookWalk,
              child: Text('Book a walk'),
            ),
            const SizedBox(height: 20), // Spacing between the buttons
            ElevatedButton(
              onPressed: _bookSitter,
              child: Text('Book a sitter'),
            ),
            const SizedBox(height: 20), // Spacing between the buttons
            const Text("Map has been removed"),
          ],
        ),
      ),
      bottomNavigationBar: CustomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTap,
      ),
    );
  }
}
