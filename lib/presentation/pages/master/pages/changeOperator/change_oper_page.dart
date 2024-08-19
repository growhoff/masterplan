import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/widgets/content_change_oper.dart';


class ChangeOperatorPage extends StatelessWidget {
  const ChangeOperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitChangeOperator>(
      create: (context) => CubitChangeOperator(stateMain.listAreaMachine!),
      child: const ChangeOperatorContent(),
    );
  }
}
