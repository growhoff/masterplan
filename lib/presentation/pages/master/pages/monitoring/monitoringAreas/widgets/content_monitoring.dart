import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/domain/model/item_machine_monitor.dart';
import '../bloc/cubit.dart';
import 'table_content_cell.dart';
import 'table_content_row.dart';
import 'table_content_row_line.dart';
import 'table_content_row_status.dart';
import 'calendar.dart';
import 'button_change.dart';

class ContentListWidgetMaster extends StatelessWidget {
  const ContentListWidgetMaster(this.changeId, this.listStatusActiveNew, this.statusActiveList, this.maxChange, {super.key});
  // final List<ItemMachineMonitorMaster> monitorList;
  final int changeId;
  final List<StatusMachineDTO> statusActiveList;
  final List<ItemMachineMonitorMaster> listStatusActiveNew;
  final int maxChange;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Card(child: Calendar()),
        const SizedBox(height: 8),
      maxChange > 0 
        ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(maxChange, (int index) => ButtonChange(index+1)),
        )
        : const Text('Нет смен'),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
     
      Table(
        columnWidths: const {
          0: FlexColumnWidth(3),
          1: FlexColumnWidth(0.5),
          2: FlexColumnWidth(0.5),
          3: FlexColumnWidth(3),
          4: FlexColumnWidth(4),
          5: FlexColumnWidth(1),
        },
        defaultColumnWidth: const FlexColumnWidth(),
        border: TableBorder.all(color: Colors.black),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          const TableRow(
              decoration: BoxDecoration(color: Colors.grey),
              children: [
                TableCell(child: TableContentCell('Наименование')),
                TableCell(child: TableContentCell('Инв.№')),
                TableCell(child: TableContentCell('Кол-во\nчасов')),
                TableCell(child: TableContentCell('Оператор')),
                TableCell(child: TableContentCell('Временная диаграмма')),
                TableCell(child: TableContentCell('Статус станка')),
              ]),
          ...List.generate(
              listStatusActiveNew.length,
              (index) => TableRow(children: [
                    TableContentRow(listStatusActiveNew[index].machine.name),
                    TableContentRow('${listStatusActiveNew[index].machine.inventoryNumber}'),
                    TableContentRow('${listStatusActiveNew[index].machine.shiftSchedule?.timeChange}'),
                    TableContentRow('${listStatusActiveNew[index].listStatus.isNotEmpty ? listStatusActiveNew[index].listStatus.first.user != null ? listStatusActiveNew[index].listStatus.first.user?.fio : '-' : '-'}'),
                    TableContentRowLine(listStatusActiveNew[index]),
                    TableContentRowStatus(statusActiveList[index].name, context.read<CubitMonitoringAreas>().convertColor(statusActiveList[index].id), listStatusActiveNew[index]),
                  ]))
        ],
      )
      ],
    );
  }
}