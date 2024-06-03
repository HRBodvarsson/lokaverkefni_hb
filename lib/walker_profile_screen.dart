import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'calendar_screen.dart';

class WalkerProfileScreen extends StatefulWidget {
  final String walkerId;

  const WalkerProfileScreen({
    super.key,
    required this.walkerId,
  });

  @override
  WalkerProfileScreenState createState() => WalkerProfileScreenState();
}

class WalkerProfileScreenState extends State<WalkerProfileScreen> {
  Map<String, String>? walkerProfile;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final rawData = await rootBundle.loadString('assets/profiles/walker_${widget.walkerId}.csv');
      List<List<dynamic>> listData = const CsvToListConverter(eol: '\n', fieldDelimiter: ';').convert(rawData);
      setState(() {
        walkerProfile = {
          'id': listData[1][0].toString(),
          'name': listData[1][1].toString(),
          'description': listData[1][2].toString(),
          'age': listData[1][3].toString(),
          'experience_years': listData[1][4].toString(),
          'cost_hour': listData[1][5].toString(),
          'km_hour': listData[1][6].toString(),
          'rating': listData[1][7].toString(),
          'total_walks': listData[1][8].toString(),
          'photo': 'assets/images/${listData[1][9].toString().trim()}',
        };
      });
    } catch (e) {
      print('Error loading profile data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (walkerProfile == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Image with X button and verified label
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.asset(
                    walkerProfile!['photo']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 40,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.check, color: Colors.white, size: 16),
                        SizedBox(width: 5),
                        Text(
                          'verified',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Profile Name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                walkerProfile!['name']!,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            // Information Boxes
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoBox('${walkerProfile!['cost_hour']} €/hour'),
                  _buildVerticalDivider(),
                  _buildInfoBox('${walkerProfile!['km_hour']} km/hour'),
                  _buildVerticalDivider(),
                  _buildInfoBox('${walkerProfile!['rating']}', icon: Icons.star),
                  _buildVerticalDivider(),
                  _buildInfoBox('${walkerProfile!['total_walks']} walks'),
                ],
              ),
            ),
            // Description
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                walkerProfile!['description']!,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            // Availability Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalendarScreen(profileId: widget.walkerId, isWalker: true),
                    ),
                  );
                },
                child: const Text('See Availability'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text, {IconData? icon}) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.grey),
            const SizedBox(width: 5),
          ],
          Flexible(
            child: Text(
              text,
              style: const TextStyle(color: Colors.grey),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 30,
      width: 1,
      color: Colors.grey,
    );
  }
}
