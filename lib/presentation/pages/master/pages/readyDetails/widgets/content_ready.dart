import 'package:flutter/material.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand_content.dart';

class ContetnReadyMaster extends StatelessWidget {
  const ContetnReadyMaster({super.key, required this.operList, required this.machine, required this.timeWorking});
  final List<ItemOperReady> operList;
  final Machine machine;
  final int timeWorking;

  @override
  Widget build(BuildContext context) {
    return (operList.isEmpty) 
    ? const Center(child: Text('Нет готовых деталей', style: TextStyle(fontWeight: FontWeight.bold)),) 
    : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              Text('Загрузка станка - ${machine.name} ${TimeConverter().convertTimeMinHMin(timeWorking)}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const Card(
                color: Colors.black12,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                  child: RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки, мин.', text4: 'Кол. в опт. партии'),
              )),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: operList.length,
                itemBuilder: (context, index) => Card(
                  color: operList[index].list.first.status.id == 1 ? Colors.redAccent : operList[index].list.first.status.id == 2 ? Colors.amber : Colors.white,
                  child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: RowExpandContent(operation: operList[index]),
                ),),),
              // const SizedBox(height: 8),
              // SizedBox(
              //   width: double.maxFinite,
              //   child: ElevatedButton(
              //     onPressed: () => context.read<CubitReadyDetails>().updateOperation(), 
              //     child: const Text('Выгрузить'),
              //   ),
              // )
      ],
    );
  }
}