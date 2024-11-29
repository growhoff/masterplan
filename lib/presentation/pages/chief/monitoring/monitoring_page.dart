import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/chief/bloc/state.dart';
import '../monitoring/monitoringAreas/monitoring_area_page.dart';
import '../monitoring/monitoringMachine/monitoring_machine_page.dart';

class MonitoringPageChief extends StatelessWidget {
  const MonitoringPageChief({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CubitChief, StateChief>(builder: (context, state) => 
        state.isThisMonitoring 
          ? const MonitoringMachinePage()
          : const MonitoringAreasPage()
      ),
    );
  }
}