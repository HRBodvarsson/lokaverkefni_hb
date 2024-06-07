import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'database_helper.dart';

class CalendarScreen extends StatefulWidget {
  final String profileId;
  final bool isWalker;

  const CalendarScreen({super.key, required this.profileId, required this.isWalker});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  final DateTime _focusedDay = DateTime.now();
  final dbHelper = DatabaseHelper.instance;
  Map<DateTime, List<String>> _availability = {};
  DateTime? _selectedDay;
  String? _selectedHour;

  @override
  void initState() {
    super.initState();
    _loadAvailabilityData();
  }

  Future<void> _loadAvailabilityData() async {
    // For simplicity, assuming default availability from 8:00 to 22:00
    setState(() {
      _availability = {
        for (var i = 0; i < 7; i++)
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1 - i)): [
            '08:00', '09:00', '10:00', '11:00', '12:00', '13:00',
            '14:00', '15:00', '16:00', '17:00', '18:00', '19:00',
            '20:00', '21:00', '22:00'
          ],
      };
    });
  }

  List<String> _getEventsForDay(DateTime day) {
    return _availability[day] ?? [];
  }

  void _submitBooking() async {
    if (_selectedDay != null && _selectedHour != null) {
      final bookingData = {
        'profileId': widget.profileId,
        'role': widget.isWalker ? 'walker' : 'sitter',
        'date': _selectedDay!.toIso8601String(),
        'hour': _selectedHour!,
      };

      await dbHelper.insertBooking(bookingData);

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Booking Confirmation'),
              content: Text('You have booked on ${_selectedDay!.toLocal()} at $_selectedHour.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop(); // Close the CalendarScreen
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a date and hour')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final daysOfWeek = List<DateTime>.generate(7, (index) => _focusedDay.subtract(Duration(days: _focusedDay.weekday - 1 - index)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Availability'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysOfWeek.length,
              itemBuilder: (context, index) {
                final day = daysOfWeek[index];
                return Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        DateFormat('EEEE, MMM d').format(day),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Expanded(
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            childAspectRatio: 5,
                          ),
                          itemCount: _getEventsForDay(day).length,
                          itemBuilder: (context, hourIndex) {
                            final hour = _getEventsForDay(day)[hourIndex];
                            bool isBooked = false; // Replace with actual booking logic
                            Color hourColor = isBooked
                                ? Colors.red
                                : (_selectedDay == day && _selectedHour == hour
                                    ? Colors.blue
                                    : Colors.green);
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDay = day;
                                  _selectedHour = hour;
                                });
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 4.0),
                                color: hourColor,
                                child: Center(
                                  child: Text(
                                    hour,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (_selectedDay != null && _selectedHour != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _submitBooking,
                child: const Text('Submit Booking'),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              '$DateTime',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
