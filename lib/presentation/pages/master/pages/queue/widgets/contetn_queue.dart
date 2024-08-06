import 'package:flutter/material.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'reorder_widget.dart';
import 'row_list_four.dart';
import '../../queue/model/item_machine.dart';

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
      activeStage = itemMachine.activeOper!.list.first.stage.number;
      activeBatch = '${batch.code} ${batch.name}';
      activeOper = '${oper.code} ${oper.name}';
      activeTime = '${itemMachine.activeOper!.time}';
      activeCount = '${itemMachine.activeOper!.list.length}';
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Время работы ${itemMachine.machine.name}: ${TimeConverter().convertTimeMinHMin(itemMachine.time)}', style: const TextStyle(fontWeight: FontWeight.bold)),
        // const SizedBox(height: 2),
        /*
        SizedBox(
          child: Row(
            children: [
              // Expanded(
              //   flex: 6,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
              //     ),
              //     onPressed: () => Navigator.pushNamed(context, '/addOperationPage'),
              //     child: const Text('Добавить операцию', textAlign: TextAlign.center),
              //   ),
              // ),
              // const Spacer(),
              // Expanded(
              //   flex: 6,
              //   child: ElevatedButton(
              //     style: ButtonStyle(
              //       padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 8, horizontal: 16)),
              //     ),
              //     onPressed: () => context.read<CubitMaster>().saveDate(itemMachine.listOper),
              //     child: const Text('Сохранить изменения', textAlign: TextAlign.center),
              //   ),
              // ),
            ],
          ),
        ),
        */

        // const Divider(),
        // const SizedBox(height: 8),
        
        const SizedBox(height: 8),
        const Card(
          color: Colors.white38,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: RowListFour(text0: '№ этапа', text1: 'Деталь', text2: 'Номер операции', text3: 'Время обработки, мин.', text4: 'Кол. в оп. партии', text5: 'Количество в группе'),
          ),
        ),
        // const SizedBox(height: 0),
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