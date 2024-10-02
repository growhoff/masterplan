import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/distrib_item_details.dart';
import 'package:master_plan/domain/usecase/color_priority.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/dialog_work.dart';
// import '../model/distrib_item.dart';

class TitleItem extends StatelessWidget {
  const TitleItem(this.oper, this.mod, {super.key});
  final DistribItemDetails oper;
  final bool mod;
  @override
  Widget build(BuildContext context) {
    List<String> listId = [];
    for (var element in oper.listOperat) {
      listId.add('${element.chiefBatchId}');
    }
    return Card(
      color: Colors.white70,
      child: Row(
        children: [
          Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(8), child: CircleAvatar(backgroundColor: ColorPriority.getColor(oper.orderPriority), radius: 15,child: Text('${oper.orderPriority}')))),
          Expanded(flex: 4, child: Padding(padding: const EdgeInsets.all(8), child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(oper.detailNumber, style: TextStyle(color: mod ? Colors.amber : Colors.black, fontWeight: FontWeight.w700)),
              Text('${oper.operationName} ${oper.countTransfer != 0 ? '(переходов - ${oper.countTransfer})' : ''}', style: TextStyle(color: mod ? Colors.amber : Colors.black)),
            ],
          ))),
          Expanded(flex: 1, child: Padding(padding: const EdgeInsets.all(8), child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${oper.count}', textAlign: TextAlign.center),
              IconButton(onPressed: () => showDialog(context: context, builder: (context) => const DialogWork(),), icon: const Icon(Icons.propane_tank_outlined))
            ],
          ))),
        ],
      ),

    );
  }
}