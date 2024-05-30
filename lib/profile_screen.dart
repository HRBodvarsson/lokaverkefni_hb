import 'dart:io';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final Map<String, dynamic> profileData;

  const ProfileScreen({super.key, required this.profileData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Profile'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              profileData['image'] == null
                  ? const Text('No image selected.')
                  : Image.file(
                      profileData['image'] as File,
                      height: 200,
                    ),
              const SizedBox(height: 20),
              Text(
                'Pet\'s Name: ${profileData['petName'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Owner\'s Name: ${profileData['ownerName'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Type of Dog: ${profileData['selectedDogType'] ?? ''}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Characteristics:',
                style: TextStyle(fontSize: 16),
              ),
              ...List.generate(
                profileData['characteristics'].length,
                (index) {
                  if (profileData['characteristics'][index]) {
                    return Text(
                      '- ${profileData['characteristicOptions'][index]}',
                      style: const TextStyle(fontSize: 16),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}