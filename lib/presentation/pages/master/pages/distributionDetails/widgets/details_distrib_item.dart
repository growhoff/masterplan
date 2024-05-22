import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'dropdawn_custom.dart';

class TitleItem extends StatelessWidget {
  const TitleItem(this.oper, this.color, {super.key});
  final DistribItem oper;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Этап № ${oper.stageNumber}'),
            const SizedBox(height: 2),
            Text('Деталь № ${oper.detailNumber}'),
            const SizedBox(height: 2),
            Text('Операция: ${oper.operationName}'),
            const SizedBox(height: 2),
            Text('Кол-во на участке: ${oper.listOperat.length}'),
            // const SizedBox(height: 2),
            // const Row(children: [
            //   Text('T п.з.: 0'),
            //   SizedBox(width: 10),
            //   Text('T шт.к.: 0')
            // ],)
          ],
        ),
      ),
    );
  }
}

class BodyItem extends StatelessWidget {
  const BodyItem(this.index, this.color, {super.key});
  final int index;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              List<String> list = [];
              for (var machine in state.machineList!) {
                list.add(machine.name);
              }
              return DropdownButtonCustom(list, index);
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child:  Text('Введите кол-во деталей, передаваемое на станок:')),
                Expanded(child: SizedBox(
                  width: 100, 
                  child: TextFormField(
                    onChanged: (value) => context.read<CubitDistributionDetails>().setCount(index, value),
                )))
              ],
            )
          ],
        ),
      ),
    );
  }
}