import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/name_index.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
import 'contetn_queue.dart';

class ElementBarQueue extends StatelessWidget {
  const ElementBarQueue({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitOperatQueueChief, StateOperatQueueChief>(
      builder:(context, state) {
        List<NameIndex> listItemArea = [];
        if (state.listAreaMachine.isNotEmpty){
          for (var i = 0; i < state.listAreaMachine.length; i++) {
            listItemArea.add(NameIndex(name: state.listAreaMachine[i].area.name, index: i));
          }        
        }
        return state.listAreaMachine.isNotEmpty 
      ? Column(
        children: [
            Container(
              decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
              child: DropdownButton<int>(
                isExpanded: true,
                underline: Container(),
                borderRadius: BorderRadius.circular(12),
                hint: const Text('Выберите участок'),
            
                value: state.activeArea,
                items: listItemArea.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name)),).toList(),
                selectedItemBuilder: (context) => listItemArea.map((e) => Center(child: Text(e.name),)).toList(),
                onChanged: (value) => value != null ? context.read<CubitOperatQueueChief>().setActiveArea(value) : null,
              ),
            ),
            const SizedBox(height: 20),
            state.listResOper.isNotEmpty 
              ? ContetnQueue(batchListQueue: state.listResOper)
              : const Center(child: Text('Список пуст'))
        ],
      )
      : const Center(child: CircularProgressIndicator());
      }
    );
  }
}