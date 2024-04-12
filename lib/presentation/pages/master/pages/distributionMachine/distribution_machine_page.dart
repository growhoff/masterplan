import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/widgets/data_list.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
            BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
              if ((state.operatorOperationsList!.length > 0) || (state.operatorOperationsList != null)){ return DataList(state.operatorOperationsList!);}
              else {return const Text('Список пуст');}
              
            }),
             const SizedBox(height: 8),
             SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(onPressed: (){}, child: const Text('Отправить на распределение')))
            ],
          )
        ),
      ),
    );
  }
}