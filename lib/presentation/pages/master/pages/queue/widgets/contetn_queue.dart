import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/item_machine.dart';
import 'package:master_plan/domain/usecase/color_priority.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/widgets/reorderable_icon_widget.dart';
import 'package:master_plan/theme/theme.dart';
// import 'package:master_plan/domain/usecase/time_converter.dart';
import 'reorder_widget.dart';
// import 'row_list_four.dart';

class ContetnQueue extends StatelessWidget {
  const ContetnQueue({super.key, required this.itemMachine, required this.isGroup});
  final ItemMachine itemMachine;
  final bool isGroup;
  @override
  Widget build(BuildContext context) {
    String activeBatch = '';
    String activeOper = '';
    // String activeTime = '';
    // String activeCount = '';
    // String activeStage = '';
    int priority = 0;
    bool? mod;
    int timeSH = 0;
    int timePZ = 0;
    int lengthPath = 0;
    if (itemMachine.activeOper != null){
      final batch = itemMachine.activeOper!.list.first.batch;
      final oper = itemMachine.activeOper!.list.first.operation;
      // activeStage = '${itemMachine.activeOper!.list.first.batch.order?.number}.${itemMachine.activeOper!.list.first.batch.number}.${itemMachine.activeOper!.list.first.stage.number}';
      activeBatch = '${batch.numberRS} ${batch.name}';
      activeOper = '${oper.code} ${oper.name}';
      // activeTime = '${itemMachine.activeOper!.time}';
      // activeCount = '${itemMachine.activeOper!.list.length}';
      priority = batch.order == null ? 0 : batch.order!.priority;
      mod = itemMachine.activeOper!.list.first.modific;
      timePZ = oper.timepz;
      timeSH = oper.timeSH;
      lengthPath = itemMachine.activeOper!.list.length;
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
            color: AppColors.notModific,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(child: ReorderableIconWidget(0, false)),
                  Expanded(child: Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(backgroundColor: ColorPriority.getColor(priority), radius: 15,child: Text('$priority')))),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(activeBatch, textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.w700, color: mod != null ? AppColors.modific : AppColors.black)),
                        Text(activeOper, textAlign: TextAlign.left, style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                       padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Text((timeSH + (timePZ / lengthPath)).toStringAsFixed(2), style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),//T шт. + Т п. з./кол-во
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('1', textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),
                              Text('-', textAlign: TextAlign.center, style: TextStyle(color: mod != null ? AppColors.modific : AppColors.black)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  //инфо
                  const Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(Icons.minor_crash_outlined, color: Colors.greenAccent,)
                    ),
                  ),
                  ],
                ),
          ),
        ),
          
          

        const SizedBox(height: 8),
        Reorder(itemMachine.listPathOper, isGroup)
      ],
    );
  }
}