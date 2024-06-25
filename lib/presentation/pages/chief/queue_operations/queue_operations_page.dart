import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import 'widgets/element_bar.dart';

class QueueOperatPageMasterChief extends StatelessWidget {
  const QueueOperatPageMasterChief({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitOperatQueueMasterChM>(
      create: (context) => CubitOperatQueueMasterChM(stateMain.machineList, stateMain.queueList, stateMain.machineIdList!, stateMain.user!.id, stateMain.listArea!, stateMain.listAreaMachine!),
      child: const QueuePageChiefContent(),
    );
  }
}

class QueuePageChiefContent extends StatelessWidget {
  const QueuePageChiefContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding:  EdgeInsets.all(16),
              child: ElementBarQueue()),
        ),
      );
  }
}