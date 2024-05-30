import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMonitoring, StateMonitoring>(builder: (context, state) => TableCalendar(
              calendarFormat: CalendarFormat.week,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              rowHeight: 43,
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 30),
              focusedDay: state.days,
              selectedDayPredicate: (day) => isSameDay(day, state.days),
              onDaySelected: (selectedDay, focusedDay) {
                context.read<CubitMonitoring>().setDate(selectedDay);
                // context.read<CubitMain>().getShiftsDistribution(selectedDay);
              },
            ));
  }
}