import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import 'widgets/element_bar.dart';

class QueuePageMasterChM extends StatelessWidget {
  const QueuePageMasterChM({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitQueueMasterChM>(
      create: (context) => CubitQueueMasterChM(stateMain.queueList,  stateMain.user!.id, stateMain.listArea!, stateMain.listAreaMachineUser!),
      child: const QueuePageMasterContent(),
    );
  }
}

class QueuePageMasterContent extends StatelessWidget {
  const QueuePageMasterContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Очередь деталей')),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding:  EdgeInsets.all(16),
              child: ElementBarQueue()),
        ),
      ),
    );
  }
}