import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/dispatcher/dispatcher_analytics_page/dispatcher_analytics_cubit/dispatcher_analytics_2_cubit.dart';

 selectDateWidget({
  required BuildContext context,
  required DispatcherAnalytics2Cubit cubit,
}) async {
  DateTime start = DateTime(2024);
  DateTime end = DateTime.now();

  final dateTimeRange = await showDateRangePicker(
      context: context, firstDate: start, lastDate: end);

  if (dateTimeRange != null) {
    cubit.timeStart = dateTimeRange.start;
    cubit.timeEnd = dateTimeRange.end;
  }

  cubit.selectDate();
}
