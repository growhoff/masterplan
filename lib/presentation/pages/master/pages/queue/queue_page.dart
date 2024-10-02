import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/widgets/dialog_saver.dart';
import './bloc/cubit.dart';
import './widgets/element_bar.dart';

class QueuePageMaster extends StatelessWidget {
  const QueuePageMaster({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitQueueMaster>(
      create: (context) => CubitQueueMaster(stateMain.user!.id, stateMain.listAreaMachine!),
      child: Scaffold(
        body: const QueuePageMasterContent(), 
        appBar: AppBar(
          title: const Text('Очередь деталей на\nстанках', textAlign: TextAlign.center),
          actions: [IconButton(onPressed: (){}, icon: const Icon(Icons.filter_alt_outlined))],
          leading: BlocBuilder<CubitMain,StateMain>(
            buildWhen: (previous, current) => previous.isSaveOrder != current.isSaveOrder,
            builder: (context, stateM) => BackButton(onPressed: () async{
              if (stateM.isSaveOrder){
                bool? val = await showDialog(context: context, builder: (context) => const DialogSaver());
                if (val != null && context.mounted){
                  if (val == true){await context.read<CubitQueueMaster>().saveDate();}
                  if (context.mounted) context.read<CubitQueueMaster>().close();
                  if (context.mounted) Navigator.pop(context);
                }
              } else {
                Navigator.pop(context);
              }
            }),
          ),
        ),
      ),
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
        children: const [
          SafeArea(
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), child: ElementBarQueue()),
          )],
      ),
    );
  }
}