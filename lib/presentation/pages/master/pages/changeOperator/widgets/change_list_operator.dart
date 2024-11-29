import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/shifts_machine_active.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/item_machine_change.dart';

class ChangeListOperator extends StatelessWidget {
  const ChangeListOperator(this.list, {super.key});
  final List<ShiftsMachineActive> list;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      controller: ScrollController(),
      itemCount: list.length,
      itemBuilder: (context, index) => ItemMachineChange(list[index], index),
      );
    
    // Column(
    //   children: list.map((element) => ItemMachineChange(element)).toList(),
    // );
  }
}
