import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  final String walkerId;

  const CalendarScreen({super.key, required this.walkerId});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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
          Expanded(
            child: ListView.builder(
              itemCount: _getEventsForDay(_selectedDay ?? _focusedDay).length,
              itemBuilder: (context, index) {
                final event = _getEventsForDay(_selectedDay ?? _focusedDay)[index];
                return ListTile(
                  title: Text(event),
                  onTap: () {
                    // Handle booking
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
