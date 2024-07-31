import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
            Visibility(
              visible: state.listAreaMachine.length > 1,
              child: DropAreaQueue(state.activeArea, state.listItemArea),
            ),
            const SizedBox(height: 8),
            DropMachineQueue(state.activeMachine, state.listItemMachine),
            const SizedBox(height: 8),
            state.listMachine!.isNotEmpty
            ? ContetnQueue(itemMachine: state.listMachine![state.activeMachine])
            : const Center(child: CircularProgressIndicator())
        ],
      )
      : const Center(child: Text('Нет станков')),
    );
  }
}

