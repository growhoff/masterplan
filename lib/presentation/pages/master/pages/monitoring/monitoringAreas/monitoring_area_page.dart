import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringAreas/widgets/content_bar.dart';
import 'bloc/cubit.dart';
// import 'package:flutter/services.dart';

class MonitoringAreasPage extends StatelessWidget {
  const MonitoringAreasPage({super.key});
  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitMonitoringAreas>(
      create: (context) => CubitMonitoringAreas(stateMain.listAreaMachine!),
      child: Scaffold(body: const MonitoringPageContentArea(), appBar: AppBar(title: const Text('Монитор 2'), actions: [IconButton(onPressed: () => context.read<CubitMain>().toggleMonitor(), icon: const Icon(Icons.transform_rounded, color: Colors.amber,))])),
    );
  }
}

    // SystemChrome.setPreferredOrientations([
    //         DeviceOrientation.landscapeRight,
    //         DeviceOrientation.landscapeLeft,
    // ]);