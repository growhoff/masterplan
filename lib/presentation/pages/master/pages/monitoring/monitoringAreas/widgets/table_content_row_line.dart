import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/item_machine_monitor.dart';
import 'status_line.dart';

class TableContentRowLine extends StatelessWidget {
  const TableContentRowLine(this.itemMachine,{super.key});
  final ItemMachineMonitorMaster itemMachine;
  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: StatusLine(itemMachine.listStatus, itemMachine.machine),
      ),
    );
  }
}
