import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/domain/model/item_machine_monitor.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import '../bloc/cubit.dart';
import 'calendar.dart';
import 'button_change.dart';
import 'status_item.dart';
import 'status_line.dart';

class ContentListWidgetMaster extends StatelessWidget {
  const ContentListWidgetMaster(this.monitor, this.changeId, this.listStatusActive, this.statusActive, this.listShifts, {super.key});
  final ItemMachineMonitorMaster monitor;
  final int changeId;
  final StatusMachineDTO statusActive;
  final List<MonitoringMachine> listStatusActive;
  final List<ShiftsDistributionDTO> listShifts;
  @override
  Widget build(BuildContext context) {
    String nameOperator = '-';
    // if (listStatusActive.isNotEmpty){
    //   if (listStatusActive.first.user != null){
    //     nameOperator = listStatusActive.first.user!.fio;
    //   }
    // }
    if (listShifts.isNotEmpty){
      for (var element in listShifts) {
        if (element.changeId == changeId) nameOperator = element.user!.fio;
      }
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(child: Text('${monitor.machine.name} станок / Оператор: $nameOperator', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold))),
            const SizedBox(width: 10),
            Flexible(
              child: Visibility(visible: statusActive.id != -1, child: Card(
                color: statusActive.id != -1 ? context.read<CubitMonitoringMachine>().convertColor(statusActive.id) : Colors.white, 
                child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(statusActive.id != -1 ? statusActive.name : ''),
              ),)),
            )
          ],
        ),
        const SizedBox(height: 8),
        const Card(child: Calendar()),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(monitor.machine.shiftSchedule!.count, (int index) => ButtonChange(index+1)),
        ),

      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
      StatusLine(listStatusActive, monitor.machine),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
        const Card(
          color: Color.fromARGB(255, 212, 212, 212),
          child:  Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 4, child: Text('Статус')),
                Expanded(flex: 2,child: Text('Начало')),
                Expanded(flex: 2,child: Text('Конец')),
                Expanded(flex: 2,child: Text('Общее')),
                Expanded(child: Text('%')),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        listStatusActive.isEmpty 
        ? const Center(child: Text('Список пуст')) 
        : ListView.separated(
            shrinkWrap: true,
            itemCount: listStatusActive.length,
            itemBuilder: (context, index) => StatusItem(monitor.machine, item: listStatusActive[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 3),
          )
      ],
    );
  }
}