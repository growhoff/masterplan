import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/button_change.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/change_list_operator.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/drop_area.dart';
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
                  BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(builder: (context, state) => Visibility(
                      visible: state.listAreaMachine.length > 1,
                      child: DropAreaChangeOper(state.activeArea, state.listItemArea),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonChangeOper(1),
                      Spacer(),
                      ButtonChangeOper(2)
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