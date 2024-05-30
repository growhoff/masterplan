import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'row_list.dart';

class ActiveOperationCard extends StatelessWidget {
  const ActiveOperationCard({super.key, required this.operJob});
  final OperatorOperations? operJob;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: Column(
        children: [
          const RowList(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки',),
          const SizedBox(height: 8),
          RowList(text1: operJob != null ? '${operJob!.batch.number} ${operJob!.batch.name}' : 'none', text2: operJob != null ? '${operJob!.operation.number} ${operJob!.operation.name}' : 'none', text3: '${operJob != null ? operJob!.timeplan : 'none'}',),
        ],
      ),
    );
  }
}