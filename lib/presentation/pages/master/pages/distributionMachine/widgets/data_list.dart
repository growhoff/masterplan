import 'package:flutter/material.dart';

class DataList extends StatefulWidget {
  const DataList({
    super.key,
  });

  @override
  State<DataList> createState() => _DataListState();
}

class _DataListState extends State<DataList> {
  static const numItems = 5;
  List<bool> selected = List<bool>.generate(numItems, (int index) => false);

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
          numItems,
          (int index) => DataRow(
            cells: [
              DataCell(
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Этап № [stageNumber $index]'),
                      const Text('Операция № [operationNumber]'),
                      const Text('[operationName]'),
                      const Text('количество [1] / [2]')
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
