import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/widgets/change_list_operator.dart';
import 'widgets/calendar.dart';

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitMaster>(
      create: (context) => CubitMaster(),
      child: const MasterContent(),
    );
  }
}

class MasterContent extends StatelessWidget {
  const MasterContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [  
                  
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  const Text('Распределение на станки'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => Expanded(flex: 5, child: ElevatedButton(onPressed: () => context.read<CubitMaster>().setChange(1), style: ElevatedButton.styleFrom(backgroundColor: state.change == 1 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('1 смена')))),
                      const Spacer(),
                      BlocBuilder<CubitMaster, StateMaster>(builder: (context, state) => Expanded(flex: 5,child: ElevatedButton(onPressed: () => context.read<CubitMaster>().setChange(2), style: ElevatedButton.styleFrom(backgroundColor: state.change == 2 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('2 смена'))))
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CubitMain, StateMain>(builder: (context, state) => ChangeListOperator(state.shiftsList!)),
                ],
              ),
              ),
          ),
        );
  }
}
