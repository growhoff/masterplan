import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/widgets/dialog_button_group.dart';
import '../widgets/drop_area.dart';
import '../widgets/drop_machine.dart';
import '../../queue/bloc/cubit.dart';
import '../../queue/bloc/state.dart';
import 'contetn_queue.dart';

class ElementBarQueue extends StatelessWidget {
  const ElementBarQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitQueueMaster, StateQueueMaster>(
      builder:(context, state) => 
      state.listItemMachine.isNotEmpty
      ? Column(
        children: [
         state.listMachine!.isEmpty
        ? const Text('')
        : Visibility(
          visible: state.listMachine![state.activeMachine].listPathOper.isNotEmpty,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: ()async{
                  int? val = 0;
                  val = await showDialog<int>(context: context,builder: (BuildContext context) => const DialogButtonGroup());
                  if (val == 1){}
                  switch (val){
                    case 1: if (context.mounted) context.read<CubitQueueMaster>().groupNameOper();break;
                    case 2: if (context.mounted) context.read<CubitQueueMaster>().groupStageNumber();break;
                    default: break;
                  } 
                }, child: const Tooltip(message: 'Группировка', child: Icon(Icons.group))),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: !state.isGroup ? null : ()=> context.read<CubitQueueMaster>().reGroup(), child: const Tooltip(message: 'Разгруппировка', child: Icon(Icons.group_off_sharp))),
                ],
              ),
              Row(
                children: [
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: () => context.read<CubitQueueMaster>().getUp(), child: const Icon(Icons.arrow_upward)),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: () => context.read<CubitQueueMaster>().getDown(), child: const Icon(Icons.arrow_downward)),
                ],
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
            Visibility(
              visible: state.listAreaMachine.length > 1,
              child: DropAreaQueue(state.activeArea, state.listItemArea),
            ),
            const SizedBox(height: 8),
            DropMachineQueue(state.activeMachine, state.listItemMachine),
            const SizedBox(height: 8),
            state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : state.listMachine!.isNotEmpty 
              ? ContetnQueue(itemMachine: state.listMachine![state.activeMachine], isGroup: state.isGroup)
              : const Center(child: Text('Пусто'))
        ],
      )
      : const Center(child: Text('Нет станков')),
    );
  }
}

