import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import 'widgets/element_bar.dart';

class QueueOperatPageMasterChM extends StatelessWidget {
  const QueueOperatPageMasterChM({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitOperatQueueChief>(
      create: (context) => CubitOperatQueueChief(stateMain.queueList, stateMain.user!.id, stateMain.listArea!, stateMain.listAreaMachine!),
      child: const QueuePageChiefMasContent(),
    );
  }
}

class QueuePageChiefMasContent extends StatelessWidget {
  const QueuePageChiefMasContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Очередь операций')),
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