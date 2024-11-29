import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/item_machine_monitor.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringAreas/widgets/dialog_info_status.dart';

class TableContentRowStatus extends StatelessWidget {
  const TableContentRowStatus(this.text, this.color, this.itemMachine, {super.key});
  final String text;
  final Color color;
  final ItemMachineMonitorMaster itemMachine;
  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      child: GestureDetector(
        onTap: () => showDialog(context: context, builder: (context) => DialogInfoStatus(itemMachine.listStatus.last),),
        child: Container(
          margin: const EdgeInsets.all(10),
          color: color,
          child: Text(
            text,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
