import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import './widgets/element_bar.dart';

class ReadyDetailsPageChM extends StatelessWidget {
  const ReadyDetailsPageChM({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitMain = context.read<CubitMain>().state;
    return BlocProvider<CubitReadyDetailsChM>(
      create: (context) => CubitReadyDetailsChM(cubitMain.machineList, cubitMain.machineIdList!, cubitMain.listAreaMachineUser!),
      child: const ReadyDetailsContent(),
    );
  }
}

class ReadyDetailsContent extends StatelessWidget {
  const ReadyDetailsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text('Готовые детали')),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child:  ElementBarReady()
          ),
        ),
      ),
    );
  }
}
