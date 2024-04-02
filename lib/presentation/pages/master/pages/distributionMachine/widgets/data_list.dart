import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/stage_master_operations.dart';

class DataList extends StatefulWidget {
  const DataList(this.listOper, {super.key});
  final List<StageMasterOperations> listOper;
  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {

  late List<bool> selected;
  late List<StageMasterOperations> listOper;
  @override
  void initState() {
    listOper = widget.listOper;
    selected = List<bool>.generate(listOper.length, (int index) => false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return DataTable(
        dataRowHeight: 80,
        columns: const [
          DataColumn(
            label: Text('Этапы'),
          ),
        ],
        rows: List<DataRow>.generate(
          listOper.length,
          (int index) => DataRow(
            cells: [
              DataCell(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Этап № ${listOper[index].stageNumber}'),
                      Text('Операция № ${listOper[index].operationNumber}'),
                      Text(listOper[index].operationName),
                      Text('количество ${listOper[index].quantity} / ${listOper[index].operationsListLength}')
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
        ));
  }
}
