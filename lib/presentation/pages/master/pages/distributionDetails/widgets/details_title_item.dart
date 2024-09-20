import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/distrib_item_details.dart';
// import '../model/distrib_item.dart';

class TitleItem extends StatelessWidget {
  const TitleItem(this.oper, this.color, {super.key});
  final DistribItemDetails oper;
  final Color color;
  @override
  Widget build(BuildContext context) {
    List<String> listId = [];
    for (var element in oper.listOperat) {
      listId.add('${element.chiefBatchId}');
    }
    return Card(
      color: color,
      child: Row(
        children: [
          Expanded(flex: 10, child: Padding(padding: const EdgeInsets.all(8), child: Text('${oper.detailNumber}\n${oper.operationName} ${oper.countTransfer != 0 ? '(переходов - ${oper.countTransfer})' : ''}'))),
          const Expanded(flex: 2, child: Padding(padding: EdgeInsets.all(8), child: CircleAvatar(backgroundColor: Colors.greenAccent, radius: 15,child: Text('0')))),
          Expanded(flex: 4, child: Padding(padding: const EdgeInsets.all(8), child: Text('${oper.count}', textAlign: TextAlign.center,))),
        ],
      ),

    );
  }
}