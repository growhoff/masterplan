import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';


class StatusItem extends StatelessWidget {
  const StatusItem({super.key, required this.item, required this.allTime});
  final ItemMachineStatus item;
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
                          color: context.read<CubitMonitoring>().convertColor(item.status.id),
                          width: 10,
                          height: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(item.status.name)
                      ],
                    )),
                    Expanded(flex: 2,child: Text(context.read<CubitMonitoring>().convertTimeZone(item.timeStart))),
                    Expanded(flex: 2,child: Text(context.read<CubitMonitoring>().convertTimeZone(item.timeEnd))),
                    Expanded(flex: 2,child: Text(context.read<CubitMonitoring>().differenceTime(item.timeWorking))),
                    Expanded(child: Text('${((item.timeWorking / 43200) * 100).round()}%')),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.comment),
          ],
        ),
      ),
    );
  }
}