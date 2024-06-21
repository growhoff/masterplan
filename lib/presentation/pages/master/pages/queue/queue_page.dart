import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './bloc/cubit.dart';
import './widgets/element_bar.dart';

class QueuePageMaster extends StatelessWidget {
  const QueuePageMaster({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitQueueMaster>(
      create: (context) => CubitQueueMaster(stateMain.machineList, stateMain.queueList, stateMain.machineIdList!, stateMain.user!.id),
      child: const QueuePageMasterContent(),
    );
  }
}

class QueuePageMasterContent extends StatelessWidget {
  const QueuePageMasterContent({super.key});
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