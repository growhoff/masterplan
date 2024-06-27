import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';
import './calendar.dart';
import 'button_change.dart';
import 'status_item.dart';
import 'status_line.dart';

class ContentListWidgetMaster extends StatelessWidget {
  const ContentListWidgetMaster(this.monitor, this.changeId, {super.key});
  final ItemMachineMonitorMaster monitor;
  final int changeId;
  @override
  Widget build(BuildContext context) {
    List<MonitoringMachine> listStatus = [];
    for (var element in monitor.listStatus) {
      if (element.changeId == changeId) listStatus.add(element);
    }
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('${monitor.machine.name} станок / Оператор: ${listStatus.isNotEmpty ? listStatus.first.user!.fio : '-'} ', textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            Visibility(visible: monitor.statusActive != null, child: Card(color: monitor.statusActive != null ? context.read<CubitMonitoring>().convertColor(monitor.statusActive!.id) : Colors.white, child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(monitor.statusActive != null ? monitor.statusActive!.name : ''),
            ),))
          ],
        ),
        const SizedBox(height: 8),
        const Card(child: Calendar()),
        const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ButtonChange(1),
            Spacer(),
            ButtonChange(2),
          ],
        ),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
      StatusLine(listStatus),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 4, child: Text('Статус')),
            Expanded(flex: 2,child: Text('Начало')),
            Expanded(flex: 2,child: Text('Конец')),
            Expanded(flex: 2,child: Text('Общее')),
            Expanded(child: Text('%')),
          ],
        ),
        const SizedBox(height: 8),
        listStatus.isEmpty 
        ? const Center(child: Text('Список пуст')) 
        : ListView.separated(
            shrinkWrap: true,
            itemCount: listStatus.length,
            itemBuilder: (context, index) => StatusItem(item: listStatus[index], allTime: monitor.allTime),
            separatorBuilder: (context, index) => const SizedBox(height: 3),
          )
      ],
    );
  }
}