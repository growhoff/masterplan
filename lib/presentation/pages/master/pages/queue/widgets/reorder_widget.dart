import 'package:master_plan/presentation/pages/master/pages/queue/widgets/reorderable_icon_widget.dart';
import '../bloc/cubit.dart';
import 'row_list_four.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Reorder extends StatelessWidget {
  const Reorder(this.list, {super.key});
  final List<OperatorOperations> list;
  @override
  Widget build(BuildContext context) {
    return (list.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        const RowListFour(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки'),
        const SizedBox(height: 8),
        ReorderableListView.builder(
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) => Row(
          key: ValueKey(index),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: ReorderableIconWidget(index)),
            Expanded(flex: 2, child: Text('${list[index].batch.number} ${list[index].batch.name}', textAlign: TextAlign.center)),
            Expanded(flex: 4, child: Text('${list[index].operation.number} ${list[index].operation.name}', textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text('${list[index].timeplan}', textAlign: TextAlign.center)),
            //передать на готовые детали
            Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMaster>().updateOperationReady(list[index].id), icon: const Icon(Icons.check_rounded))),
            //передать на распределение
            Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMaster>().updateOperationDistribMaster(list[index].id), icon: const Icon(Icons.close)))
          ],
        ),
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {newIndex = newIndex - 1;}
          final element  = list.removeAt(oldIndex);
          list.insert(newIndex, element);
        }
      )
      ],
    );
  }
}