import 'dart:io';
import 'database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> eraseProfileData() async {
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.deleteAllProfiles();
  print("User profile data erased.");
}

