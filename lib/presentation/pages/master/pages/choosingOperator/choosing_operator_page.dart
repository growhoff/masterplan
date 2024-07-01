import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:intl/intl.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/bloc/state.dart';

class ChoosingOperatorPage extends StatelessWidget {
  const ChoosingOperatorPage({super.key, required this.machine, required this.change, required this.time});
  final Machine machine;
  final DateTime time;
  final int change;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitChoosingOperator(change,machine,time),
      child: const ChoosingOperatorContent(),
    );
  }
}

class ChoosingOperatorContent extends StatelessWidget {
  const ChoosingOperatorContent({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
          final user = state.user!;
          return Column(children: [
            const Text('Выберите оператора'),
            Text('${user.id} / ${user.fio} / ${user.position.name} / ${user.area!.name}',style: const TextStyle(fontSize: 12)),
            ]);
        }),
        ),
      body: SafeArea(
    child: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child:  BlocBuilder<CubitChoosingOperator, StateChoosingOperator>(builder:(context, stateoper) => Column(
              children: [
               Text(stateoper.machine.name),
               Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Смена № ${stateoper.change}'),
                    Text(DateFormat('dd/MM/yyyy').format(stateoper.time))
                  ],
                 ),
               const SizedBox(height: 8),
                BlocBuilder<CubitMain, StateMain>(
                 builder:(context, state) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.operatorList!.length,
                  itemBuilder: (context, index) => ListTile(
                    tileColor: stateoper.user == state.operatorList![index].id ? Colors.green : Colors.white10,
                    title: Text(state.operatorList![index].fio),
                    onTap: () => context.read<CubitChoosingOperator>().saveUser(state.operatorList![index].id),
                  ),
                  ),
               ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    onPressed: (){
                      context.read<CubitChoosingOperator>().insertTable();
                      Navigator.pop(context);
                    },
                    child: const Text('Выбрать'),
                  ),
                )
              ],
            ),
        ),
        )
      ),
    ),
    );
  }
}
