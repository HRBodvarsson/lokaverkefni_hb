import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lokaverkefni_hb/image_handler.dart';
import 'package:csv/csv.dart';
import 'fonts.dart';
import 'main_menu_screen.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  CreateProfileScreenState createState() => CreateProfileScreenState();
}

class CreateProfileScreenState extends State<CreateProfileScreen> {
  File? _image;
  String? _errorMessage;
  String? _petName;
  String? _ownerName;
  String? _selectedDogType;
  List<String> _dogTypes = [];
  final List<bool> _characteristics = List<bool>.filled(5, false);
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
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    try {
      final rawData = await rootBundle.loadString('assets/types_of_dogs.csv');
      List<List<dynamic>> listData =
          const CsvToListConverter().convert(rawData);
      setState(() {
        _dogTypes = listData.map((row) => row[0].toString()).toList();
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final file = await ImageHandler.pickImage();
      setState(() {
        _image = file;
        _errorMessage = null; // Clear any previous error message
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _submitProfile() {
    final profileData = {
      'image': _image,
      'petName': _petName,
      'ownerName': _ownerName,
      'selectedDogType': _selectedDogType,
      'characteristics': _characteristics,
    };

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => MainMenuScreen(profileData: profileData),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Profile',
          style: AppFonts.button,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _image == null
                  ? const Text('No image selected.')
                  : Image.file(
                      _image!,
                      height: 200,
                    ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: const Text('Upload Image'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Pet\'s Name'),
                  onChanged: (value) {
                    setState(() {
                      _petName = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Owner\'s Name'),
                  onChanged: (value) {
                    setState(() {
                      _ownerName = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  hint: const Text('Choose type of dog'),
                  value: _selectedDogType,
                  items: _dogTypes.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDogType = newValue;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ExpansionTile(
                  title: const Text('Characteristics'),
                  children: _characteristicOptions.map((String option) {
                    int index = _characteristicOptions.indexOf(option);
                    return CheckboxListTile(
                      title: Text(option),
                      value: _characteristics[index],
                      onChanged: (bool? value) {
                        setState(() {
                          _characteristics[index] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              ElevatedButton(
                onPressed: _submitProfile,
                child: Text('Submit Profile', style: AppFonts.button,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
