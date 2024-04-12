import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/model/item_text_ready_queue.dart';
import 'reorderable_icon_widget.dart';

class ReorderWidget extends StatefulWidget {
  const ReorderWidget(this.list, {super.key, required this.header});
  final List<Batch> list;
  final Widget header;
  @override
  State<ReorderWidget> createState() => _ReorderWidgetState();
}

class _ReorderWidgetState extends State<ReorderWidget> {

  List<ItemTextReadyQueue> listOperations = [];

  @override
  void initState() {
    for (var batch in widget.list) {
      for (var stage in batch.stageList) {
        for (var operat in stage.operationList) {
          int time = 0;
          for (var transfer in operat.transferList) {
            time += transfer.timepz;
          }
          listOperations.add(ItemTextReadyQueue(detailNumber: batch.number, operationName: operat.name, timeFact: time));
        }
      }
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return (listOperations.isEmpty) 
    ? const Center(child: Text('Список операций в очереди пуст')) 
    : ReorderableListView.builder(
        // buildDefaultDragHandles: false,
        shrinkWrap: true,
        header: widget.header,
        itemBuilder: (context, index) => Row(
          key: ValueKey(index),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: ReorderableIconWidget(index)),
            Expanded(flex: 2, child: Text('${listOperations[index].detailNumber}')),
            Expanded(flex: 2, child: Text(listOperations[index].operationName)),
            Expanded(flex: 2, child: Text('${listOperations[index].timeFact}')),
            Expanded(child: IconButton(onPressed: () => listOperations.removeAt(index), icon: const Icon(Icons.close)))
          ],
        ),
        itemCount: listOperations.length, 
        onReorder: (oldIndex, newIndex) {
          if (newIndex > oldIndex) {newIndex = newIndex - 1;}
          final element  = listOperations.removeAt(oldIndex);
          listOperations.insert(newIndex, element);
          setState(() {});
        }
      );
  }
}