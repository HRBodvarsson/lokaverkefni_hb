import 'package:flutter/material.dart';
import 'ui/custom_navbar.dart';
import 'list_of_walkers.dart';
import 'list_of_sitters.dart';

class MainMenuScreen extends StatefulWidget {
  final Map<String, dynamic>? profileData;

  const MainMenuScreen({super.key, this.profileData});

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
      MaterialPageRoute(builder: (context) => const ListOfWalkers()),
    );
  }

  void _navigateToSitters(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ListOfSitters()),
    );
  }

  void _bookWalk() {
    _navigateToWalkers(context);
  }

  void _bookSitter() {
    _navigateToSitters(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _bookWalk,
              child: const Text('Book a walk'),
            ),
            const SizedBox(height: 20), // Spacing between the buttons
            ElevatedButton(
              onPressed: _bookSitter,
              child: const Text('Book a sitter'),
            ),
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
