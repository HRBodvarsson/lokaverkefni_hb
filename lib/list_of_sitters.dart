import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'sitter_profile_screen.dart'; // Assuming you have a similar profile screen for sitters

class ListOfSitters extends StatefulWidget {
  const ListOfSitters({super.key});

  @override
  ListOfSittersState createState() => ListOfSittersState();
}

class ListOfSittersState extends State<ListOfSitters> {
  List<Map<String, String>> _sitters = [];

  @override
  void initState() {
    super.initState();
    _loadCsvData();
  }

  Future<void> _loadCsvData() async {
    try {
      final rawData = await rootBundle.loadString('assets/dog_sitters.csv');
      List<List<dynamic>> listData = const CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(rawData);
      setState(() {
        _sitters = listData.skip(1).map((row) {
          return {
            'id': row[0].toString(),
            'name': row[1].toString(),
            'description': row[2].toString(),
            'photo': 'assets/images/${row[3].toString().trim()}', // Correct the path
          };
        }).toList();
        // Debug print
      });
    } catch (e) {
      // Debug print
    }
  }

  void _navigateToSitterProfile(BuildContext context, String sitterId, String sitterName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SitterProfileScreen(sitterId: sitterId), // Create a similar screen for sitters
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dog Sitters'),
      ),
      body: _sitters.isEmpty
          ? const Center(child: Text('No sitters available')) // Show message if no sitters
          : ListView.builder(
              itemCount: _sitters.length,
              itemBuilder: (context, index) {
                final sitter = _sitters[index];
                return GestureDetector(
                  onTap: () => _navigateToSitterProfile(context, sitter['id']!, sitter['name']!),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color.fromARGB(255, 96, 96, 96), width: 1.0),
                      ),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          sitter['photo']!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                sitter['name']!,
                                style: Theme.of(context).textTheme.displayMedium,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                sitter['description']!,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
