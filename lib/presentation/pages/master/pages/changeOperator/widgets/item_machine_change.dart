import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
import 'package:master_plan/domain/model/shifts_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/choosing_operator_page.dart';

class ItemMachineChange extends StatelessWidget {
  const ItemMachineChange(this.machineShif, {super.key});
  final ShiftsMachine machineShif;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 233, 233, 233),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Text(machineShif.machine.name),
            Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(
                  builder: (context, state) {
                    ShiftsDistribution? changeItem;
                    if (state.change == 1) {
                      changeItem = machineShif.changeOne;
                    } else {
                      changeItem = machineShif.changeTwo;
                    }
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(changeItem != null ? changeItem.user.fio : 'none'),
                        Row(
                          children: [
                            IconButton(
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ChoosingOperatorPage(
                                            machine: machineShif.machine,
                                            time: state.days,
                                            change: state.change))),
                                icon: const Icon(Icons.add)),
                            Visibility(
                                visible: (changeItem != null),
                                child: IconButton(
                                    onPressed: () => context
                                        .read<CubitChangeOperator>()
                                        .deleteShifts(changeItem!.id),
                                    icon: const Icon(Icons.delete)))
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
