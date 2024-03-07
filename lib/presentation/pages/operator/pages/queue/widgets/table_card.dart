
import 'package:flutter/material.dart';

import '../model/operation.dart';
import 'row_list.dart';

class TableCard extends StatelessWidget {
  const TableCard(
      {super.key,
      required this.color,
      required this.heder,
      required this.list});
  final Color color;
  final Widget heder;
  final List<Operation> list;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Column(
        children: [
          heder,
          const SizedBox(height: 8),
          ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) => RowList(
                text1: list[index].plan,
                text2: list[index].operation,
                text3: list[index].time),
            itemCount: list.length,
          ),
        ],
      ),
    );
  }
}