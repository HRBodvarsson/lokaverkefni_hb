import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'walker_profile_screen.dart';

class ListOfWalkers extends StatefulWidget {
  const ListOfWalkers({super.key});

  @override
  ListOfWalkersState createState() => ListOfWalkersState();
}

class ListOfWalkersState extends State<ListOfWalkers> {
  List<Map<String, String>> _walkers = [];

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    try {
      final rawData = await rootBundle.loadString('assets/dog_walkers.csv');
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      setState(() {
        _walkers = listData.skip(1).map((row) {
          return {
            'id': row[0].toString(),
            'name': row[1].toString(),
            'description': row[2].toString(),
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading CSV data: $e');
    }
  }

  void _navigateToWalkerProfile(BuildContext context, String walkerId, String walkerName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WalkerProfileScreen(walkerId: walkerId, walkerName: walkerName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Walkers'),
      ),
      body: ListView.builder(
        itemCount: _walkers.length,
        itemBuilder: (context, index) {
          final walker = _walkers[index];
          return ListTile(
            title: Text(walker['name']!),
            subtitle: Text(walker['description']!),
            onTap: () => _navigateToWalkerProfile(context, walker['id']!, walker['name']!),
          );
        },
      ),
    );
  }
}
