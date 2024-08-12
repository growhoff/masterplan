import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import '../../monitoring/bloc/cubit.dart';
import '../../monitoring/model/item_machine_monitor.dart';
import './calendar.dart';
import 'button_change.dart';
import 'status_item.dart';
import 'status_line.dart';

class ContentListWidgetMaster extends StatelessWidget {
  const ContentListWidgetMaster(this.monitor, this.changeId, this.listStatusActive, this.statusActive, {super.key});
  final ItemMachineMonitorMaster monitor;
  final int changeId;
  final StatusMachineDTO statusActive;
  final List<MonitoringMachine> listStatusActive;
  @override
  Widget build(BuildContext context) {
    String nameOperator = '-';
    if (listStatusActive.isNotEmpty){
      if (listStatusActive.first.user != null){
        nameOperator = listStatusActive.first.user!.fio;
      }
      
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${monitor.machine.name} станок / Оператор: $nameOperator', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Visibility(visible: statusActive.id != -1, child: Card(
              color: statusActive.id != -1 ? context.read<CubitMonitoring>().convertColor(statusActive.id) : Colors.white, 
              child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(statusActive.id != -1 ? statusActive.name : ''),
            ),))
          ],
        ),
        const SizedBox(height: 8),
        const Card(child: Calendar()),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(monitor.machine.shiftSchedule!.count, (int index) => ButtonChange(index+1)),
        ),
        // ListView.separated(
        //   scrollDirection: Axis.horizontal,
        //   shrinkWrap: true,
        //   itemBuilder: (context, index) => ButtonChange(index+1), 
        //   separatorBuilder: (context, index) => const SizedBox(width: 8,), 
        //   itemCount: monitor.machine.shiftSchedule!.count
        //   ),
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     ButtonChange(1),
        //     Spacer(),
        //     ButtonChange(2),
        //   ],
        // ),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
      StatusLine(listStatusActive),
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
            itemBuilder: (context, index) => StatusItem(item: listStatusActive[index]),
            separatorBuilder: (context, index) => const SizedBox(height: 3),
          )
      ],
    );
  }
}