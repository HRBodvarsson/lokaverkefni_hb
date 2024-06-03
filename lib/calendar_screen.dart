import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'database_helper.dart';

class CalendarScreen extends StatefulWidget {
  final String profileId;
  final bool isWalker;

  const CalendarScreen({super.key, required this.profileId, required this.isWalker});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String? _selectedHour;
  final dbHelper = DatabaseHelper.instance;
  Map<DateTime, List<String>> _availability = {};

  @override
  void initState() {
    super.initState();
    _loadAvailabilityData();
  }

  Future<void> _loadAvailabilityData() async {
    // For simplicity, assuming default availability from 8:00 to 22:00
    setState(() {
      _availability = {
        for (var i = 0; i < 30; i++)
          DateTime.now().add(Duration(days: i)): [
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Availability'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            eventLoader: _getEventsForDay,
          ),
          const SizedBox(height: 8.0),
          if (_selectedDay != null)
            Expanded(
              child: Column(
                children: [
                  Text(
                    'Available Hours for ${_selectedDay!.toLocal()}'.split(' ')[0],
                    style: Theme.of(context).textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _getEventsForDay(_selectedDay!).length,
                      itemBuilder: (context, index) {
                        final hour = _getEventsForDay(_selectedDay!)[index];
                        return ListTile(
                          title: Text(hour),
                          selected: _selectedHour == hour,
                          onTap: () {
                            setState(() {
                              _selectedHour = hour;
                            });
                          },
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _submitBooking,
                    child: const Text('Submit Booking'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
