import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {

  DateTime day = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: day,
              onDaySelected: (selectedDay, focusedDay) {
                day = focusedDay;
                setState(() {});
              },
            );
  }
}