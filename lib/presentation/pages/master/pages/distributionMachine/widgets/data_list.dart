import 'package:flutter/material.dart';
// import 'package:master_plan/domain/model/stage_master_operations.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/model/item_text.dart';

class DataList extends StatefulWidget {
  const DataList(this.listOper, {super.key});
  final List<ZOperatorOperations>? listOper;
  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {

  late List<bool> selected;
  List<ItemText> listItem = [];
  @override
  void initState() {
    if (widget.listOper!.length > 0){
      for (var itemOper in widget.listOper!) {
      for (var stage in itemOper.batch.stageList) {
        for (var operation in stage.operationList) {
          listItem.add(ItemText(stageId: stage.id, stageNumber: stage.number, operationId: operation.id, operationNumber: operation.number, operationName: operation.name, detailName: itemOper.batch.name, quantity: stage.operationList.length));
        }
      }
    }
    }
    if (listItem.isNotEmpty) selected = List<bool>.generate(listItem.length, (int index) => false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return listItem.isNotEmpty ? DataTable(
        dataRowHeight: 80,
        columns: const [
          DataColumn(
            label: Text('Этапы'),
          ),
        ],
        rows: List<DataRow>.generate(
          listItem.length,
          (int index) => DataRow(
            cells: [
              DataCell(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Этап № ${listItem[index].stageNumber}'),
                      Text('Операция № ${listItem[index].operationNumber}'),
                      Text(listItem[index].detailName),
                      Text('количество ${listItem[index].operationNumber} / ${listItem[index].quantity}')
                    ], 
                  ),
                ),
              )
            ],
            selected: selected[index],
            onSelectChanged: (bool? value) {
              selected[index] = value!;
              setState(() {});
            },
          ),
        )) : const Center(child: Text('Список операция пуст'));
  }
}
