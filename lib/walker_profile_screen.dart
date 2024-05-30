import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';

class WalkerProfileScreen extends StatefulWidget {
  final String walkerId;
  final String walkerName;

  const WalkerProfileScreen({required this.walkerId, required this.walkerName, super.key});

  @override
  WalkerProfileScreenState createState() => WalkerProfileScreenState();
}

class WalkerProfileScreenState extends State<WalkerProfileScreen> {
  List<Map<String, String>> _profileDetails = [];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final rawData = await rootBundle.loadString('assets/walker_${widget.walkerId}.csv');
      List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
      setState(() {
        _profileDetails = listData.map((row) {
          return {
            'detail': row[0].toString(),
            'description': row[1].toString(),
          };
        }).toList();
      });
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.walkerName),
      ),
      body: _profileDetails.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _profileDetails.length,
              itemBuilder: (context, index) {
                final detail = _profileDetails[index];
                return ListTile(
                  title: Text(detail['detail']!),
                  subtitle: Text(detail['description']!),
                );
              },
            ),
    );
  }
}
