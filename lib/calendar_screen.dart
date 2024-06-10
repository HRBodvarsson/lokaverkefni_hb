import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'widgets/calendar.dart';

class CalendarScreen extends StatefulWidget {
  final String profileId;
  final bool isWalker;

  const CalendarScreen({super.key, required this.profileId, required this.isWalker});

  @override
  CalendarScreenState createState() => CalendarScreenState();
}

class CalendarScreenState extends State<CalendarScreen> {
  final dbHelper = DatabaseHelper.instance;

  void _onBookingSelected(DateTime selectedDay, String selectedHour) async {
    final bookingData = {
      'profileId': widget.profileId,
      'role': widget.isWalker ? 'walker' : 'sitter',
      'date': selectedDay.toIso8601String(),
      'hour': selectedHour,
    };

    await dbHelper.insertBooking(bookingData);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Booking Confirmation'),
            content: Text('You have booked on ${selectedDay.toLocal()} at $selectedHour.'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Availability'),
      ),
      body: CalendarWidget(onBookingSelected: _onBookingSelected),
    );
  }
}
