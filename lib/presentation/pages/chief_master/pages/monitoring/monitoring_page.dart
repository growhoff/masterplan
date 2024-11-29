import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/cubit.dart';
import '../../bloc/state.dart';
import '../monitoring/monitoringAreas/monitoring_area_page.dart';
import '../monitoring/monitoringMachine/monitoring_machine_page.dart';

class MonitoringPageChM extends StatelessWidget {
  const MonitoringPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<CubitChiefMaster, StateChiefMaster>(builder: (context, state) => 
        state.isThisMonitoring 
          ? const MonitoringMachinePage()
          : const MonitoringAreasPage()
      ),
    );
  }
}