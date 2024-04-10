
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/queue/model/item_operation.dart';
import 'row_list.dart';

class TableCard extends StatelessWidget {
  const TableCard(
      {super.key,
      required this.color,
      required this.heder,
      required this.list});
  final Color color;
  final Widget heder;
  final List<ItemOperation> list;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        children: [
          heder,
          const SizedBox(height: 8),
          list == [] 
          ? const Text('List null')
          : ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => RowList(
                text1: '${list[index].detailNumber}',
                text2: list[index].operationName,
                text3: '${list[index].timeFact}'),
            itemCount: list.length,
          ),
        ],
      ),
    );
  }
}