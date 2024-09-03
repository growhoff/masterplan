import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringMachine/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringMachine/widgets/content_bar.dart';

class MonitoringMachinePage extends StatelessWidget {
  const MonitoringMachinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitMonitoringMachine>(
      create: (context) => CubitMonitoringMachine(stateMain.listAreaMachine!),
      child: const MonitoringPageContentMachine(),
    );
  }
}