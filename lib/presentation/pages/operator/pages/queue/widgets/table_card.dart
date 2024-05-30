import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'row_list.dart';

class TableCard extends StatelessWidget {
  const TableCard(
      {super.key,
      required this.color,
      required this.heder,
      required this.list});
  final Color color;
  final Widget heder;
  final List<OperatorOperations> list;
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
                text1: '${list[index].batch.number} ${list[index].batch.name}',
                text2: '${list[index].operation.number} ${list[index].operation.name}',
                text3: '${list[index].timefact}'),
            itemCount: list.length,
          ),
        ],
      ),
    );
  }
}