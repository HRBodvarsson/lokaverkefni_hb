import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<List<String>> _dogData = [];
  List<String> _dogTypes = [];
  String? _selectedDogType;
  bool _isLoading = true;
  String? _errorMessage;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Profiles'),
      ),
      body: Center(
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
                    ],
                  ),
      ),
    );
  }
}
