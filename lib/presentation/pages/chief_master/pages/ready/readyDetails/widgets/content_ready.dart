import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
import '../bloc/cubit.dart';
// import '../model/item_oper.dart';
import '../model/status_next.dart';
import '../widgets/row_expand.dart';
import '../widgets/row_expand_content.dart';

class ContetnReadyMaster extends StatelessWidget {
  const ContetnReadyMaster({super.key, required this.operList, required this.machine, required this.timeWorking, required this.l});
  final List<OptPathOperations> operList;
  final Machine machine;
  final int timeWorking;
  final List<StatusNext> l;

  @override
  Widget build(BuildContext context) {
    return (operList.isEmpty) 
    ? const Center(child: Text('Нет готовых деталей', style: TextStyle(fontWeight: FontWeight.bold)),) 
    : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              Text('Загрузка станка - ${machine.name}: $timeWorking минут', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки, мин.', text4: 'Кол. в опт. партии'),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: operList.length,
                itemBuilder: (context, index) => Card(
                  color: l[index].status == 1 ? Colors.redAccent : l[index].status == 2 ? Colors.amber : Colors.white,
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RowExpandContent(operation: operList[index], indexOper: index, intL: l[index].status),
                ),),),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () => context.read<CubitReadyDetailsChM>().updateOperation(), 
                  child: const Text('Выгрузить'),
                ),
              )
      ],
    );
  }
}