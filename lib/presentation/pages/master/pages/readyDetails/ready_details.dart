import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/bloc/state.dart';
// import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_operation.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/element_bar.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/row_expand_content.dart';
// import '../../../../widgets/element_bar.dart';

class BrakReadyDetailsPage extends StatelessWidget {
  const BrakReadyDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubitMain = context.read<CubitMain>().state;
    return BlocProvider<CubitReadyDetails>(
      create: (context) => CubitReadyDetails(cubitMain.machineList, cubitMain.machineIdList!),
      child: const BrakReadyDetailsContent(),
    );
  }
}

class BrakReadyDetailsContent extends StatelessWidget {
  const BrakReadyDetailsContent({super.key});
  @override
  Widget build(BuildContext context) {
    return  const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child:  ElementBarReady()
        ),
      ),
    );
  }
}

class ContetnReadyBrak extends StatelessWidget {
  const ContetnReadyBrak({super.key, required this.operList, required this.machine, required this.timeWorking, required this.l});
  final List<ItemOperReady> operList;
  final Machine machine;
  final int timeWorking;
  final List<int> l;

  @override
  Widget build(BuildContext context) {
    return (operList.isEmpty) 
    ? const Center(child: Text('Нет готовых деталей', style: TextStyle(fontWeight: FontWeight.bold)),) 
    : Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              Text('Время работы станка - ${machine.name}: $timeWorking минут', style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Divider(),
              const SizedBox(height: 8),
              const RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки', text4: 'Кол. в опт. партии'),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: operList.length,
                itemBuilder: (context, index) => Card(
                  color: l[index] == 5 ? Colors.redAccent : l[index] == 4 ? Colors.amber : Colors.white,
                  child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RowExpandContent(operation: operList[index], indexOper: index, intL: l[index]),
                ),),),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () => context.read<CubitReadyDetails>().updateOperation(), 
                  child: const Text('Вызгрузить'),
                ),
              )
      ],
    );
  }
}