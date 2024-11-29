import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/pages/tableInfo/model/table_model.dart';
import 'package:master_plan/theme/theme.dart';

class TableInfoNew extends StatelessWidget {
  const TableInfoNew(this.listOper, this.indexActive, {super.key});
  final List<TableModel> listOper;
  final int indexActive;
  @override
  Widget build(BuildContext context) {
    return 
    listOper.isEmpty ? const Text('Список пуст')
    :  Column(
      children: [
        const Card(
          color: Colors.black12,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: Text('№\nп/п', textAlign: TextAlign.center)),
                Expanded(flex: 5, child: Text('Наименование\nоперации', textAlign: TextAlign.center)),
                Expanded(flex: 3, child: Text('Номер,\nнаменование\nучастка', textAlign: TextAlign.center))
              ],
            ),
          )
        ),
        const SizedBox(height: 8),
        Column(
          children: [
            ...List.generate(
              listOper.length,
              (index) => 
              Card(
                color: index == indexActive ? AppColors.blueMaket : index > indexActive ? AppColors.greyMaket : AppColors.greenMaket,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: Text('${listOper[index].order}', textAlign: TextAlign.center)),
                      Expanded(flex: 5, child: Text(listOper[index].nameOper, textAlign: TextAlign.center)),
                      Expanded(flex: 3, child: Text(listOper[index].nameArea, textAlign: TextAlign.center))
                    ],
                  ),
                ),
              )
            ),
          ]
        )
      ],
    );
  }
}
