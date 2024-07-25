import 'package:flutter/material.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import '../model/item_machine.dart';
import 'reorder_widget.dart';
import 'row_list_four.dart';

class ContetnQueue extends StatelessWidget {
  const ContetnQueue({super.key, required this.itemMachine});
  final ItemMachine itemMachine;

  @override
  Widget build(BuildContext context) {
    String activeBatch = '';
    String activeOper = '';
    String activeTime = '';
    String activeCount = '';
    if (itemMachine.activeOper != null){
      final batch = itemMachine.activeOper!.list.first.batch;
      final oper = itemMachine.activeOper!.list.first.operation;
      activeBatch = '${batch.code} ${batch.name}';
      activeOper = '${oper.code} ${oper.name}';
      activeTime = '${itemMachine.activeOper!.time}';
      activeCount = '${itemMachine.activeOper!.list.length}';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Время работы ${itemMachine.machine.name}: ${TimeConverter().convertTimeMinHMin(itemMachine.time)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        Visibility(
          visible: itemMachine.activeOper != null,
          child: Card(
          color: Colors.greenAccent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
            children: [
              const RowListFour(text1: 'Деталь', text2: 'Номер операции', text3: 'Время обработки, мин.', text4: 'Кол. в оп. партии',),
              RowListFour(text1: activeBatch, text2: activeOper, text3: activeTime, text4: activeCount,),
            ],
                  ),
          )),),
        const SizedBox(height: 8),
        Reorder(itemMachine.listOper)
      ],
    );
  }
}