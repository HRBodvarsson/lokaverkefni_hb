import 'dart:io';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  const ProfileScreen({super.key, required this.profileData});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  late Map<String, dynamic> _profileData;
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

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
    _profileData = Map<String, dynamic>.from(widget.profileData);
    _profileData['characteristics'] = _parseCharacteristics(_profileData['characteristics']);
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

  String _characteristicsToString(List<bool> characteristics) {
    return characteristics.map((item) => item.toString()).join(',');
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveProfileData() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      _profileData['characteristics'] = _characteristicsToString(List<bool>.from(_profileData['characteristics']));
      final dbHelper = DatabaseHelper.instance;
      await dbHelper.updateProfile(_profileData);
      _toggleEditMode();
      await _fetchLatestProfileData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Profile'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: _isEditing ? _saveProfileData : _toggleEditMode,
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _profileData['image'] == null
                    ? const Text('No image selected.')
                    : Image.file(
                        _profileData['image'] as File,
                        height: 200,
                      ),
                const SizedBox(height: 20),
                _buildTextField(
                  label: 'Pet\'s Name',
                  initialValue: _profileData['petName'] ?? '',
                  enabled: _isEditing,
                  onSaved: (value) {
                    _profileData['petName'] = value;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Owner\'s Name',
                  initialValue: _profileData['ownerName'] ?? '',
                  enabled: _isEditing,
                  onSaved: (value) {
                    _profileData['ownerName'] = value;
                  },
                ),
                const SizedBox(height: 10),
                _buildTextField(
                  label: 'Type of Dog',
                  initialValue: _profileData['selectedDogType'] ?? '',
                  enabled: _isEditing,
                  onSaved: (value) {
                    _profileData['selectedDogType'] = value;
                  },
                ),
                const SizedBox(height: 10),
                const Text(
                  'Characteristics:',
                  style: TextStyle(fontSize: 16),
                ),
                ...List.generate(
                  _profileData['characteristics'].length,
                  (index) {
                    if (_profileData['characteristics'][index] is bool && _profileData['characteristics'][index]) {
                      return Text(
                        '- ${_characteristicOptions[index]}',
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
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required bool enabled,
    required void Function(String?) onSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        initialValue: initialValue,
        enabled: enabled,
        onSaved: onSaved,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
}
