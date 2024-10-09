import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import '../monitoring/monitoringAreas/monitoring_area_page.dart';
import '../monitoring/monitoringMachine/monitoring_machine_page.dart';
import 'package:flutter/services.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
    ]);
    return BlocBuilder<CubitMain, StateMain>(
      buildWhen: (previous, current) => previous.isMonitor != current.isMonitor,
      builder: (context, state) => state.isMonitor 
        ? const MonitoringMachinePage()
        : const MonitoringAreasPage()
    );
  }
}