import 'package:master_plan/presentation/pages/master/pages/queue/model/item_oper.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/widgets/reorderable_icon_widget.dart';
import '../bloc/cubit.dart';
import 'row_list_four.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
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
          bool? mod = list[index].list.first.modific;
          return Container(
            key: ValueKey(index),
            color:  mod != null ? Colors.amberAccent : Colors.white,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: ReorderableIconWidget(index)),
              Expanded(flex: 3, child: Text('${list[index].list.first.batch.number} ${list[index].list.first.batch.name}', textAlign: TextAlign.center)),
              Expanded(flex: 4, child: Text('${list[index].list.first.operation.number} ${list[index].list.first.operation.name}', textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('${list[index].time}', textAlign: TextAlign.center)),
              Expanded(flex: 2, child: Text('${list[index].list.length}', textAlign: TextAlign.center)),
              //передать на готовые детали
              Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMaster>().updateOperationReady(list[index].idPath), icon: const Icon(Icons.check_rounded))),
              //передать на распределение
              Expanded(child: IconButton(onPressed: () => context.read<CubitQueueMaster>().updateOperationDistribMaster(list[index].idPath), icon: const Icon(Icons.close)))
            ],
                  ),
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