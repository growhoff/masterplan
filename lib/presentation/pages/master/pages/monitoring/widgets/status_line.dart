import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import '../bloc/cubit.dart';

class StatusLine extends StatelessWidget {
  const StatusLine(this.list, {super.key});
  final List<MonitoringMachine> list; 
  @override
  Widget build(BuildContext context) {
    int lastTime = 43200;
    for (var element in list) {
      lastTime -= element.timeWorking!;
    }
    return SizedBox(
      height: 25,
      child: Row(
        children: [...list.map((e) => Expanded(
          flex: e.timeWorking!,
          child: Container(decoration: BoxDecoration(color: context.read<CubitMonitoring>().convertColor(e.statusMachine!.id)))
          )
        ).toList(),
        Expanded(flex: lastTime,
          child: Container(decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black), color: Colors.white))
          ),
          ]
      ),
    );
  }
}