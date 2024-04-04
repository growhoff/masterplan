import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'dropdawn_custom.dart';

class ListContetnDetails extends StatelessWidget {
  const ListContetnDetails(this.oper, {super.key});
  // final StageMasterOperations oper;
  final ZOperatorOperations oper;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Этап № ${oper.batch.stageList.first.number}'), //oper.stageNumber
            const SizedBox(height: 8),
            Text('${oper.batch.number}'),//oper.planNumber
            const SizedBox(height: 8),
            Text('Операция ${oper.batch.stageList.first.operationList.first.name}'), //oper.operationName
            const SizedBox(height: 8),
            Text('кол-во на участке: ${oper.batch.count }'),//oper.quantity
            const SizedBox(height: 8),
            BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              List<String> list = [];
              for (var machine in state.area!.machineList) {
                list.add(machine.name);
              }
              return DropdownButtonCustom(list);
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('введите кол-во деталей, передаваемое на станок:'),
                SizedBox(width: 100, child: TextFormField())
              ],
            )
          ],
        ),
      ),
    );
  }
}