import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/distrib_item_details.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/master/pages/distributionDetails/model/distrib_item.dart';
import 'dropdawn_custom.dart';

class BodyItem extends StatelessWidget {
  const BodyItem(this.index, this.color, this.readOnly, this.oper, {super.key});
  final int index;
  final Color color;
  final bool readOnly;
  final DistribItemDetails oper;
  @override
  Widget build(BuildContext context) {
    // TextEditingController controllerCount = TextEditingController(text: '${oper.setCount}');
    // TextEditingController controllerOptPath = TextEditingController(text: '${oper.setOptPart}'); 
    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Этап №: ${oper.stageNumber}'),
                    const SizedBox(height: 2),
                    Text('T п.з.= ${oper.timePZ}   T шт.= ${oper.timeSh}   T шт.к.= ${(oper.timeSh + (oper.timePZ / oper.count)).toStringAsFixed(2)}'),//T шт. + Т п. з./кол-во
                  ],
                ),
                Text('ТП: ${oper.listOperat.first.batch.technology}')
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              List<String> list = [];
              for (var machine in state.machineList!) {
                list.add('${machine.name} (инв.№ ${machine.inventoryNumber})');
              }
              return DropdownButtonCustom(list, index);
            }),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child:  Text('Введите кол-во деталей, передаваемое на станок:')),
                Expanded(child: SizedBox(
                  width: 80, 
                  child: TextFormField(
                    // controller: controllerCount,  //TextEditingController(text: '${oper.setCount}'),
                    initialValue: '${oper.listOperat.length}',
                    onChanged: (value) {
                      context.read<CubitDistributionDetails>().setCount(index, value);
                      // controllerCount.text = value;
                    },
                )))
              ],
            ),
            const SizedBox(height: 8),
            oper.countTransfer <= 0 ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  flex: 2,
                  child:  Text('Введите оптимальный объем операционной партии:')),
                Expanded(child: SizedBox(
                  width: 80, 
                  child: TextFormField(
                    initialValue: '${oper.setOptPart}',
                    // controller: controllerOptPath,
                    readOnly: readOnly,
                    onChanged: (value) {
                      context.read<CubitDistributionDetails>().setOptPath(index, value);
                      // controllerOptPath.text = value;
                    },
                )))
              ],
            ) : Container(),
            const SizedBox(height: 8),
            SizedBox(
              width: double.maxFinite, 
              child: ElevatedButton(
                style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.white54)), 
                onPressed: ()=> context.read<CubitDistributionDetails>().updateOperation(index), 
                child: const Text('Добавить в задание', style: TextStyle(color: Colors.black),)))
          ],
        ),
      ),
    );
  }
}