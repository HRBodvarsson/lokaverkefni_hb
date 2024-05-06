import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Snatalabb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Snatalabb'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/logo.png', width: 100, height: 100), // Place your logo image in the assets directory
            SizedBox(height: 48), // Adds space between the logo and the buttons
            ElevatedButton(
              onPressed: () {
                // Add navigation or functionality for Dog Walker
                print('Dog Walker selected');
              },
              child: Text('Dog Walker'),
            ),
            SizedBox(height: 24), // Adds space between the buttons
            ElevatedButton(
              onPressed: () {
                // Add navigation or functionality for Dog Owner
                print('Dog Owner selected');
              },
              child: Text('Dog Owner'),
            ),
          ],
        ),
      ),
    );
  }
}
