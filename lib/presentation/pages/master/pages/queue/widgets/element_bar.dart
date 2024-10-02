import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
// import 'package:master_plan/presentation/pages/master/pages/distributionDetails/widgets/content_head_item.dart';
import 'dialog_button_group.dart';
import 'drop_area.dart';
import 'drop_machine.dart';
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


          const Card(
            color: Colors.black12,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Center(child: RotatedBox(quarterTurns: 3, child: Text('Приоритет', textAlign: TextAlign.center, style: TextStyle(fontSize: 10),)))),
                  Expanded(flex: 6, child: Text('№ чертежа, наименование\nОперация', textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text('T шт.к.\nКол-во', textAlign: TextAlign.center)),
                  Expanded(flex: 2, child: Text('Действие', textAlign: TextAlign.center)),
                ],
              ),
            ),
          ),

        //дроп панельки
        Visibility(
          visible: state.listAreaMachine.length > 1,
          child: DropAreaQueue(state.activeArea, state.listItemArea),
        ),
        const SizedBox(height: 8),
        DropMachineQueue(state.activeMachine, state.listItemMachine),
        const SizedBox(height: 8),

      
         //панель 
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
                }, child: const Tooltip(message: 'Группировка', child: Icon(Icons.view_stream, color: Colors.black,))),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: !state.isGroup ? null : ()=> context.read<CubitQueueMaster>().reGroup(), child: const Tooltip(message: 'Разгруппировка', child: Icon(Icons.view_comfy, color: Colors.black,))),
                ],
              ),
              Text('Загрузка: ${TimeConverter().convertTimeMinHMin( state.listMachine![state.activeMachine].time)}'),
              Row(
                children: [
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: () => context.read<CubitQueueMaster>().getUp(), child: const Icon(Icons.arrow_upward, color: Colors.black,)),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: const ButtonStyle(padding: WidgetStatePropertyAll( EdgeInsets.all(0))),
                  onPressed: () => context.read<CubitQueueMaster>().getDown(), child: const Icon(Icons.arrow_downward, color: Colors.black,)),
                ],
              )
            ],
          ),
        ),
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

