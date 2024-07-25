import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/change_list_operator.dart';
import 'calendar.dart';

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
                      BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => Expanded(flex: 5, child: ElevatedButton(onPressed: () => context.read<CubitChangeOperator>().setChange(1), style: ElevatedButton.styleFrom(backgroundColor: state.change == 1 ? const Color.fromARGB(255, 136, 216, 139) : const Color.fromARGB(255, 181, 197, 206), padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('1 смена', style: TextStyle(color: Colors.black))))),
                      const Spacer(),
                      BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => Expanded(flex: 5,child: ElevatedButton(onPressed: () => context.read<CubitChangeOperator>().setChange(2), style: ElevatedButton.styleFrom(backgroundColor: state.change == 2 ? const Color.fromARGB(255, 136, 216, 139) : const Color.fromARGB(255, 181, 197, 206), padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('2 смена', style: TextStyle(color: Colors.black)))))
                    ],
                  ),
                  const SizedBox(height: 8),
                  BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => 
                  state.shiftsList!.isNotEmpty 
                  ? ChangeListOperator(state.shiftsList!) 
                  : const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
              ),
          ),
        );
  }
}