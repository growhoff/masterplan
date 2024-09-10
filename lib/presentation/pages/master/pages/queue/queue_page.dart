import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import './bloc/cubit.dart';
import './widgets/element_bar.dart';

class QueuePageMaster extends StatelessWidget {
  const QueuePageMaster({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitQueueMaster>(
      create: (context) => CubitQueueMaster(stateMain.user!.id, stateMain.listAreaMachine!, context.read<CubitMaster>().state.isActiveStream),
      child: const QueuePageMasterContent(),
    );
  }
}

class QueuePageMasterContent extends StatelessWidget {
  const QueuePageMasterContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(10),
      child: ListView(
        children: const [SafeArea(
          child: Padding(padding: EdgeInsets.all(16), child: ElementBarQueue()),
        )],
      ),
    );
  }
}

/*
return WillPopScope(
      onWillPop: () async {
        final value = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: const Text('Вы действтельно хотите выйти?'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Нет'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                ElevatedButton(
                  child: const Text('Да, выйти'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          }
        );

        return value == true;},
      child: const SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding:  EdgeInsets.all(16),
              child: ElementBarQueue()),
        ),
      ),
    );
*/