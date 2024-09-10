import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/user.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:intl/intl.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/choosingOperator/bloc/state.dart';

class ChoosingOperatorPage extends StatelessWidget {
  const ChoosingOperatorPage({super.key, required this.machine, required this.change, required this.time, required this.operatorList});
  final Machine machine;
  final DateTime time;
  final int change;
  final List<User> operatorList;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CubitChoosingOperator(change,machine,time, operatorList),
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
            Text('${user.fio} / ${user.position.name} / ${user.area != null ? user.area!.name : ''}',style: const TextStyle(fontSize: 12)),
            ]);
        }),
        ),
      body: SafeArea(
    child: Stack(
      children: [
        Scrollbar(
          thickness: 10,
          thumbVisibility: true,
          radius: const Radius.circular(10),
        child: ListView(
          children: [Padding(
            padding: const EdgeInsets.all(16),
            child:  BlocBuilder<CubitChoosingOperator, StateChoosingOperator>(builder:(context, stateoper) => Column(
                  children: [
                   Card(
                     child: Padding(
                       padding: const EdgeInsets.all(12.0),
                       child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Смена № ${stateoper.change}'),
                            Text(stateoper.machine.name),
                            Text(DateFormat('dd/MM/yyyy').format(stateoper.time))
                          ],
                         ),
                     ),
                   ),
                  //  const SizedBox(height: 8),
                  //  const Divider(),
                   const SizedBox(height: 8),
                    BlocBuilder<CubitChoosingOperator, StateChoosingOperator>(
                     builder:(context, state) => ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.operatorList.length,
                      itemBuilder: (context, index) => ListTile(
                        tileColor: stateoper.user == state.operatorList[index].id ? Colors.green : Colors.white10,
                        title: Text(state.operatorList[index].fio),
                        onTap: () => context.read<CubitChoosingOperator>().saveUser(state.operatorList[index].id),
                      ),
                      ),
                   ),
                    // const SizedBox(height: 8),
                    // SizedBox(
                    //   width: double.maxFinite,
                    //   child: ElevatedButton(
                    //     onPressed: (){
                    //       context.read<CubitChoosingOperator>().insertTable();
                    //       Navigator.pop(context);
                    //     },
                    //     child: const Text('Выбрать'),
                    //   ),
                    // )
                  ],
                ),
            ),
            )],
        )
        ),
        Container(
            margin: const EdgeInsets.only(bottom: 8),
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              style: const ButtonStyle(backgroundColor: WidgetStatePropertyAll(Colors.blueAccent)),
                      onPressed: (){
                        context.read<CubitChoosingOperator>().insertTable();
                        Navigator.pop(context);
                      },
                      child: const Text('Выбрать', style: TextStyle(color: Colors.white),),
                    ),
        ),

        ]
    ),
    ),
    );
  }
}
