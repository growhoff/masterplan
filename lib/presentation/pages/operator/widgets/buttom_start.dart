import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/widgets/dialog_change.dart';

class ButtomStart extends StatelessWidget {
  const ButtomStart({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocBuilder<CubitOperator, StateOperator>(
          builder: (context, state) => ElevatedButton(
                onPressed: () {
                  if (stateMain.machineIdList != null){
                    if (!state.isStart && stateMain.machineIdList!.isNotEmpty) Navigator.pushNamed(context, '/workPage');
                    context.read<CubitOperator>().toggleBtn(stateMain.user!.id);
                  } else {
                    showDialog( context: context, builder: (BuildContext context) => const DialogChange());
                  }                 
                },
                child: Text(!state.isStart ? 'Начать смену' : 'Закончить смену'),
              ));
  }
}