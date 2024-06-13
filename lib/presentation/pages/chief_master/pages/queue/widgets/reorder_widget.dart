import '../model/item_oper.dart';
import '../widgets/reorderable_icon_widget.dart';
import '../bloc/cubit.dart';
import 'row_list_four.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Reorder extends StatelessWidget {
  const Reorder(this.list, {super.key});
  final List<ItemOper> list;
  @override
  Widget build(BuildContext context) {
    return (list.isEmpty) 
    ? const Center(child: Text('Список операций пуст')) 
    : Column(
      children: [
        const RowListFour(text1: 'Деталь', text2: 'Номер операции', text3: 'Время обработки', text4: 'Кол. в оп. партии',),
        const SizedBox(height: 8),
        ReorderableListView.builder(
        buildDefaultDragHandles: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          int time = 0;
          for (var e in list[index].list) {
            time += e.timeplan;
          }
          return Row(
          key: ValueKey(index),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: ReorderableIconWidget(index)),
            Expanded(flex: 3, child: Text('${list[index].list.first.batch.number} ${list[index].list.first.batch.name}', textAlign: TextAlign.center)),
            Expanded(flex: 4, child: Text('${list[index].list.first.operation.number} ${list[index].list.first.operation.name}', textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text('$time', textAlign: TextAlign.center)),
            Expanded(flex: 2, child: Text('${list[index].list.length}', textAlign: TextAlign.center)),
            //передать на готовые детали
            Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMasterChM>().updateOperationReady(list[index].idPath), icon: const Icon(Icons.check_rounded))),
            //передать на распределение
            Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMasterChM>().updateOperationDistribMaster(list[index].idPath), icon: const Icon(Icons.close)))
          ],
        );
        },
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