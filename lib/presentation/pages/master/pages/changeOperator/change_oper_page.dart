import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/change_list_operator.dart';

import 'widgets/calendar.dart';

class ChangeOperatorPage extends StatelessWidget {
  const ChangeOperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitChangeOperator>(
      create: (context) => CubitChangeOperator(stateMain.machineList, stateMain.machineIdList!),
      child: const ChangeOperatorContent(),
    );
  }
}

class ChangeOperatorContent extends StatelessWidget {
  const ChangeOperatorContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [  
                  const Text('Распределение на станки', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => Expanded(flex: 5, child: ElevatedButton(onPressed: () => context.read<CubitChangeOperator>().setChange(1), style: ElevatedButton.styleFrom(backgroundColor: state.change == 1 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('1 смена')))),
                      const Spacer(),
                      BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => Expanded(flex: 5,child: ElevatedButton(onPressed: () => context.read<CubitChangeOperator>().setChange(2), style: ElevatedButton.styleFrom(backgroundColor: state.change == 2 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('2 смена'))))
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => state.shiftsList!.isNotEmpty ? ChangeListOperator(state.shiftsList!) : const Center(child: CircularProgressIndicator(),)),
                ],
              ),
              ),
          ),
        );
  }
}
