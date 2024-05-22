import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'image_handler.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<List<String>> _dogData = [];
  List<String> _dogTypes = [];
  String? _selectedDogType;
  bool _isLoading = true;
  String? _errorMessage;
  File? _image;

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    try {
      final rawData = await rootBundle.loadString('assets/types_of_dogs.csv');
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      setState(() {
        _dogData = listData.map((row) => row.map((item) => item.toString()).toList()).toList();
        if (_dogData.isNotEmpty) {
          _dogTypes = _dogData.map((row) => row[0]).toList();
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _isLoading
          ? const CircularProgressIndicator()
          : _errorMessage != null
              ? Text('Error: $_errorMessage')
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
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
                    const SizedBox(height: 20),
                    _selectedDogType == null
                        ? const Text('Please select a type of dog')
                        : Text(
                            'Selected Dog Type: $_selectedDogType',
                            style: const TextStyle(fontSize: 16),
                          ),
                    const SizedBox(height: 20),
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
                  ],
                ),
    );
  }
}
