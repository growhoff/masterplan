import 'package:flutter/material.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'row_list.dart';

class TableCard extends StatelessWidget {
  const TableCard(
      {super.key,
      required this.color,
      required this.heder,
      required this.list});
  final Color color;
  final Widget heder;
  final List<ItemOperOp> list;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        children: [
          heder,
          const SizedBox(height: 8),
          list == [] 
          ? const Text('Список пуст')
          : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => RowList(
                mod: list[index].list.first.modific,
                text1: '${list[index].list.first.batch.number} ${list[index].list.first.batch.name}',
                text2: '${list[index].list.first.operation.number} ${list[index].list.first.operation.name}',
                text3: '${list[index].list.first.timeworking}',
                text4: '${list[index].list.length}',
                ),
            itemCount: list.length,
          ),
        ],
      ),
    );
  }
}