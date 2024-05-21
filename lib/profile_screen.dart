import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'dart:convert';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<List<String>> _dogData = [];

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    final rawData = await rootBundle.loadString('assets/type_of_dogs.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _dogData = listData.map((row) => row.map((item) => item.toString()).toList()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create profile'),
      ),
      body: _dogData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dogData.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_dogData[index][0]),
                  subtitle: Text(_dogData[index][1]),
                );
              },
            ),
    );
  }
}
