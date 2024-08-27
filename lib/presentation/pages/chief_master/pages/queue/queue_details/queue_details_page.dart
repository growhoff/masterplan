import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './widgets/dialog_saver.dart';
import './bloc/state.dart';
import './bloc/cubit.dart';
import './widgets/element_bar.dart';

class QueuePageMasterChM extends StatelessWidget {
  const QueuePageMasterChM({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitQueueMaster>(
      create: (context) => CubitQueueMaster(stateMain.user!.id, stateMain.listAreaMachineUser!),
      child: const QueuePageMasterContent(),
    );
  }
}

class QueuePageMasterContent extends StatelessWidget {
  const QueuePageMasterContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Очередь деталей'),
        leading: BlocBuilder<CubitQueueMaster, StateQueueMaster>(
          builder: (context, state) =>  BackButton(
            onPressed: () => state.isSaver ? showDialog(
                  context: context, 
                  builder: (BuildContext innerContext) {
                    return BlocProvider.value(value: context.watch<CubitQueueMaster>(),
                    child: Material(
                        child: BlocBuilder<CubitQueueMaster, StateQueueMaster>(builder: (context, state) => const DialogSaver()),
                      ),
                    );
                  })
                  : Navigator.pop(context),
          ),
        ),
      ),
      body: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(16), child: ElementBarQueue()),
        ),
      ),
    );
  }
}