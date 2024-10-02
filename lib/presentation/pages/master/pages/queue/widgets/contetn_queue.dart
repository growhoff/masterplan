import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/item_machine.dart';
// import 'package:master_plan/domain/usecase/time_converter.dart';
import 'reorder_widget.dart';
import 'row_list_four.dart';

class ContetnQueue extends StatelessWidget {
  const ContetnQueue({super.key, required this.itemMachine, required this.isGroup});
  final ItemMachine itemMachine;
  final bool isGroup;
  @override
  Widget build(BuildContext context) {
    String activeBatch = '';
    String activeOper = '';
    String activeTime = '';
    String activeCount = '';
    String activeStage = '';
    if (itemMachine.activeOper != null){
      final batch = itemMachine.activeOper!.list.first.batch;
      final oper = itemMachine.activeOper!.list.first.operation;
      activeStage = '${itemMachine.activeOper!.list.first.batch.order?.number}.${itemMachine.activeOper!.list.first.batch.number}.${itemMachine.activeOper!.list.first.stage.number}';
      activeBatch = '${batch.numberRS} ${batch.name}';
      activeOper = '${oper.code} ${oper.name}';
      activeTime = '${itemMachine.activeOper!.time}';
      activeCount = '${itemMachine.activeOper!.list.length}';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Text('Время работы ${itemMachine.machine.name}: ${TimeConverter().convertTimeMinHMin(itemMachine.time)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 8),
        // const Card(
        //   color: Colors.white38,
        //   child: Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: RowListFour(text0: '№ этапа', text1: 'Деталь', text2: 'Номер операции', text3: 'Время обработки, мин.', text4: 'Кол. в оп. партии', text5: 'Количество в группе'),
        //   ),
        // ),
        Visibility(
          visible: itemMachine.activeOper != null,
          child: Card(
          color: Colors.greenAccent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: RowListFour(text0: activeStage, text1: activeBatch, text2: activeOper, text3: activeTime, text4: activeCount, text5: ''),
          )),),
        const SizedBox(height: 8),
        Reorder(itemMachine.listPathOper, isGroup)
      ],
    );
  }
}