import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/shifts_machine_active.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/item_machine_change.dart';

class ChangeListOperator extends StatelessWidget {
  const ChangeListOperator(this.list, {super.key});
  final List<ShiftsMachineActive> list;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: list.map((element) => ItemMachineChange(element)).toList(),
    );
  }
}
