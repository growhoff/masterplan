import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'dropdawn_custom.dart';

class TitleItem extends StatelessWidget {
  const TitleItem(this.oper, {super.key});
  final DistribItem oper;
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
            Text('Деталь № ${oper.detailNumber}'),
            const SizedBox(height: 8),
            Text('Операция: ${oper.operationName}'),
            const SizedBox(height: 8),
            Text('Кол-во на участке: ${oper.count }'),
          ],
        ),
      ),
    );
  }
}

class BodyItem extends StatelessWidget {
  const BodyItem(this.index, {super.key});
  final int index;
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: '0');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              List<String> list = [];
              for (var machine in state.area!.machineList) {
                list.add(machine.name);
              }
              return DropdownButtonCustom(list, index);
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child:  Text('Введите кол-во деталей, передаваемое на станок:')),
                Expanded(child: SizedBox(width: 100, child: TextFormField(
                  controller: controller,
                  onSaved: (value) => context.read<CubitDistributionDetails>().setCount(index, controller.text),
                )))
              ],
            )
          ],
        ),
      ),
    );
  }
}