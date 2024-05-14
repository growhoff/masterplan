import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';

class StatusLine extends StatelessWidget {
  const StatusLine(this.list, {super.key});
  final List<ItemMachineStatus> list; 
  @override
  Widget build(BuildContext context) {
    
    return SizedBox(
      height: 25,
      child: Row(
        children: list.map((e) => Expanded(
          flex: e.timeWorking,
          child: Container(decoration: BoxDecoration(border: Border.all(width: 1, color: Colors.black), color: context.read<CubitMonitoring>().convertColor(e.status.id)))
          )
        ).toList(),
      ),
    );
  }
}