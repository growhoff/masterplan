import 'package:flutter/material.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';
import 'row_list.dart';

class ActiveOperationCard extends StatelessWidget {
  const ActiveOperationCard({super.key, required this.operJob});
  final ItemOperOp? operJob;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: Column(
        children: [
          const RowList(mod: null, text1: 'Деталь', text2: 'Операция', text3: 'Время обработки', text4: 'Кол. опт. партии'),
          const SizedBox(height: 8),
          RowList(
            mod: operJob!.list.first.modific,
            text1: operJob != null ? '${operJob!.list.first.batch.number} ${operJob!.list.first.batch.name}' : 'none',
            text2: operJob != null ? '${operJob!.list.first.operation.number} ${operJob!.list.first.operation.name}' : 'none',
            text3: operJob != null ? '${operJob!.list.first.timeplan}' : 'none',
            text4: operJob != null ? '${operJob!.list.length}' : 'none',
          ),
        ],
      ),
    );
  }
}