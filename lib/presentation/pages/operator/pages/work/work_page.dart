import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/widgets/element_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitWork>(
      create: (context) => CubitWork(stateMain.zshiftsDistributionList, stateMain.operatorOperationsList),
      child: BlocProvider<CubitTimer>(
        create: (context) => CubitTimer(context.read<CubitMain>().state.zshiftsDistributionList!.length),
        child: const ContentWork()) 
    );
  }
}

class ContentWork extends StatelessWidget {
  const ContentWork({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          appBar: AppBar(
            title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                final user = state.user!;
                return Column(
                children: [
                  const Text('Оператор'),
                  Text('${user.fio} / ${user.position.name}', style: const TextStyle(fontSize: 12)),
            ]);
          }),
          ),
          body: const SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child:  ElementBarOperator() ,
              ),
            ),
          )),
    );
  }
}
