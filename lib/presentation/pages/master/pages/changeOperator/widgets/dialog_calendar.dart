import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DialogCalendar extends StatefulWidget {
  const DialogCalendar(this.day, {super.key});
  final DateTime day;
  @override
  State<DialogCalendar> createState() => _DialogCalendarState();
}

class _DialogCalendarState extends State<DialogCalendar> {
  late DateTime days;
  @override
  void initState() {
    super.initState();
    days = widget.day;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
                title: const Text('Выбор даты'),
                content: Card(
                  child: SizedBox(
                  width: 400, 
                  height: 300, 
                  child: TableCalendar(
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              rowHeight: 43,
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: days,
              selectedDayPredicate: (day) => isSameDay(day, days),
              onDaySelected: (selectedDay, focusedDay) {
                days = selectedDay;
                setState(() {});
              },
            ),
            )),
                titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,fontSize: 20),
                actionsOverflowButtonSpacing: 20,
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, days.millisecondsSinceEpoch),
                  child: const Text('СОХРАНИТЬ'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: const Text('ОТМЕНА'),
                ),
                ],
            );
  }
}

