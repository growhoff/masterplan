import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
// import '../model/item_machine.dart';
import '../bloc/cubit.dart';


class StatusItem extends StatelessWidget {
  const StatusItem({super.key, required this.item, required this.allTime});
  final MonitoringMachine item;
  final int allTime;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                    Expanded(flex: 4, child: Row(
                      children: [
                        Container(
                          color: context.read<CubitMonitoring>().convertColor(item.statusMachine!.id),
                          width: 10,
                          height: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(item.statusMachine!.name)
                      ],
                    )),
                    Expanded(flex: 2,child: Text(context.read<CubitMonitoring>().convertTimeZone(item.timeStart))),
                    Expanded(flex: 2,child: Text(context.read<CubitMonitoring>().convertTimeZone(item.timeStop))),
                    Expanded(flex: 2,child: Text(context.read<CubitMonitoring>().differenceTime(item.timeWorking!))),
                    Expanded(child: Text('${((item.timeWorking! / 43200) * 100).round()}%')),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Деталь: ${item.batch != null ? item.batch!.number : '-'} ${item.batch != null ? item.batch!.name: ''}'),
                  const SizedBox(height: 8),
                  Text('Комментарий: ${item.comment}')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}