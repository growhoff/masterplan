import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/stage_master_operations.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'dropdawn_custom.dart';

class ListContetnDetails extends StatelessWidget {
  const ListContetnDetails(this.oper, {super.key});
  final StageMasterOperations oper;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Этап № ${oper.stageNumber}'),
            const SizedBox(height: 8),
            Text(oper.planNumber),
            const SizedBox(height: 8),
            Text(oper.operationName),
            const SizedBox(height: 8),
            Text('кол-во на участке: ${oper.quantity}'),
            const SizedBox(height: 8),
            BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              List<String> list = [];
              for (var element in state.listEquipment!) {
                list.add(element.name);
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