import 'package:flutter/material.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/model/table_model.dart';
import '../widgets/table_content_cell.dart';
import '../widgets/table_content_row.dart';

class TableInfo extends StatelessWidget {
  const TableInfo(this.listOper, this.indexActive, {super.key});
  final List<TableModel> listOper;
  final int indexActive;
  @override
  Widget build(BuildContext context) {
    return 
    listOper.isEmpty ? const Text('Null')
    : Card(
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(4),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1.5),
          // 3: FlexColumnWidth(1.5),
        },
        defaultColumnWidth: const FlexColumnWidth(),
        border: TableBorder.all(color: Colors.black),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          const TableRow(
              decoration: BoxDecoration(color: Colors.grey),
              children: [
                TableCell(child: TableContentCell('наименование\nоперации')),
                TableCell(child: TableContentCell('№')),
                TableCell(child: TableContentCell('участок')),
                // TableCell(child: TableContentCell('участок')),
                // TableCell(child: TableContentCell('кол-во\nвыполненных')),
              ]),
          ...List.generate(
              listOper.length,
              (index) => TableRow(children: [
                    TableContentRow(listOper[index].nameOper, index, indexActive),
                    TableContentRow('${listOper[index].order}', index, indexActive),
                    TableContentRow(listOper[index].nameArea, index, indexActive),
                    // TableContentRow('$index'),
                  ]))
        ],
      ),
    );
  }
}
