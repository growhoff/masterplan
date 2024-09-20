import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import '../bloc/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReorderQuereOper extends StatelessWidget {
  const ReorderQuereOper(this.operQueueList, {super.key});
  final List<ItemOperOp> operQueueList;
  @override
  Widget build(BuildContext context) {    
    return (operQueueList.isEmpty) 
    ? const Text('Список пуст') 
    : Column(
      children: [
        ReorderableListView.builder(
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        itemCount: operQueueList.length,
        itemBuilder: (context, index) {
          return Card(
            key: ValueKey(index),
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(child: ReorderableDragStartListener(index: index, child: Icon(Icons.reorder, color: operQueueList[index].list.first.modific != null ? Colors.amberAccent : Colors.black))),
                  Expanded(flex: 4, child: Text('${operQueueList[index].list.first.batch.numberRS} ${operQueueList[index].list.first.batch.name}', textAlign: TextAlign.center, style: TextStyle(color: operQueueList[index].list.first.modific != null ? Colors.amberAccent : Colors.black),)),
                  Expanded(flex: 4, child: Text('${operQueueList[index].list.first.operation.number} ${operQueueList[index].list.first.operation.name}', textAlign: TextAlign.center, style: TextStyle(color: operQueueList[index].list.first.modific != null ? Colors.amberAccent : Colors.black))),
                  Expanded(flex: 2, child: Text('${operQueueList[index].idPath}', textAlign: TextAlign.center, style: TextStyle(color: operQueueList[index].list.first.modific != null ? Colors.amberAccent : Colors.black))),
                  Expanded(flex: 2, child: Text('-', textAlign: TextAlign.center, style: TextStyle(color: operQueueList[index].list.first.modific != null ? Colors.amberAccent : Colors.black))),
                  Expanded(flex: 2, child: Text('${operQueueList[index].list.length}', textAlign: TextAlign.center, style: TextStyle(color: operQueueList[index].list.first.modific != null ? Colors.amberAccent : Colors.black))),
                ],
              ),
            ),
          ); 
        },
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {newIndex = newIndex - 1;}
          final element  = operQueueList.removeAt(oldIndex);
          operQueueList.insert(newIndex, element);
          //save
          context.read<CubitEqueueOperator>().setList(operQueueList);
        }
      )
      ],
    );
  }
}