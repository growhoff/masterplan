import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './widgets/content_bar.dart';
import './bloc/cubit.dart';
import 'package:flutter/services.dart';

class MonitoringMachinePage extends StatelessWidget {
  const MonitoringMachinePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    //горизонтальная раскладка
    SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
    ]);
    //вертикальная раскладка
    /*
    SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeRight,
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
    */
    return BlocProvider<CubitMonitoringMachine>(
      create: (context) => CubitMonitoringMachine(stateMain.listAreaMachine!),
      child: Scaffold(
        body: const MonitoringPageContentMachine(), 
        appBar: AppBar(
          title: const Text('Мониторинг'), 
          actions: [IconButton(onPressed: () => context.read<CubitMain>().toggleMonitor(), icon: const Icon(Icons.transform_rounded, color: Colors.amber,))],
        ),
      ),
    );
  }
}