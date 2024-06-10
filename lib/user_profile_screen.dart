import 'dart:io';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key, required Map profileData});

  @override
  UserProfileScreenState createState() => UserProfileScreenState();
}

class UserProfileScreenState extends State<UserProfileScreen> {
  Map<String, dynamic> _profileData = {};
  final List<String> _characteristicOptions = [
    'Is collar trained',
    'Likes to play catch',
    'Likes to run',
    'Behaves well with other dogs',
    'Behaves well with other people'
  ];

  @override
  void initState() {
    super.initState();
    _fetchLatestProfileData();
  }

  Future<void> _fetchLatestProfileData() async {
    final dbHelper = DatabaseHelper.instance;
    final allRows = await dbHelper.queryAllProfiles();
    if (allRows.isNotEmpty) {
      setState(() {
        _profileData = Map<String, dynamic>.from(allRows.first);
        _profileData['characteristics'] = _parseCharacteristics(_profileData['characteristics']);
      });
    }
  }

  List<bool> _parseCharacteristics(String characteristics) {
    return characteristics.split(',').map((item) => item.trim() == 'true').toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: _profileData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _profileData['imagePath'] == null
                        ? const Text('No image selected.')
                        : Image.file(
                            File(_profileData['imagePath']),
                            height: 200,
                          ),
                    const SizedBox(height: 20),
                    _buildProfileInfoRow(
                      label: 'Pet\'s Name',
                      value: _profileData['petName'] ?? '',
                    ),
                    _buildProfileInfoRow(
                      label: 'Owner\'s Name',
                      value: _profileData['ownerName'] ?? '',
                    ),
                    _buildProfileInfoRow(
                      label: 'Type of Dog',
                      value: _profileData['selectedDogType'] ?? '',
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                      child: Text(
                        'Characteristics:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ...List.generate(
                      _profileData['characteristics'].length,
                      (index) {
                        if (_profileData['characteristics'][index] is bool && _profileData['characteristics'][index]) {
                          return _buildCharacteristicRow(
                            characteristic: _characteristicOptions[index],
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

  Widget _buildProfileInfoRow({
    required String label,
    required String value,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 96, 96, 96), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacteristicRow({
    required String characteristic,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Color.fromARGB(255, 96, 96, 96), width: 1.0),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            '- $characteristic',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
