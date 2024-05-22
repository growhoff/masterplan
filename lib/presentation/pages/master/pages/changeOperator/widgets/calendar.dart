import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/state.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/material.dart';

class Calendar extends StatelessWidget {
  const Calendar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => TableCalendar(
              calendarFormat: CalendarFormat.month,
              headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
              rowHeight: 43,
              firstDay: DateTime.now(),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: state.days,
              selectedDayPredicate: (day) => isSameDay(day, state.days),
              onDaySelected: (selectedDay, focusedDay) {
                context.read<CubitChangeOperator>().setDate(selectedDay);
                // context.read<CubitMain>().getShiftsDistribution(selectedDay);
              },
            ));
  }
}