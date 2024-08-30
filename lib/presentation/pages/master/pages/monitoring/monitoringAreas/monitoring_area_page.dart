import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'bloc/cubit.dart';
import 'widgets/element_bar.dart';

class MonitoringAreasPage extends StatelessWidget {
  const MonitoringAreasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitMonitoringAreas>(
      create: (context) => CubitMonitoringAreas(stateMain.listAreaMachine!),
      child: const MonitoringPageContent(),
    );
  }
}


class MonitoringPageContent extends StatelessWidget {
  const MonitoringPageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ElementBarMonitor(true),
          ),
        ),
      );
  }
}