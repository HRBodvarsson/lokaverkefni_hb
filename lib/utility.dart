import 'dart:io';
import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> handleTerminalCommands() async {
  final dbHelper = DatabaseHelper.instance;



  while (true) {
    print("Enter 'e' to erase user profile data or 'q' to quit the application:");
    String? input = stdin.readLineSync();

    if (input == 'e') {
      await dbHelper.deleteAllProfiles();
      print("User profile data erased.");
    } else if (input == 'q') {
      print("Quitting the application.");
      exit(0);
    } else {
      print("Invalid command. Please try again.");
    }
  }
}

Future<void> eraseProfileData() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.deleteAllProfiles();
  print("User profile data erased.");
}

void quitApplication() {
  print("Quitting the application.");
  exit(0);
}
