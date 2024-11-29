import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/widgets/timer/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/widgets/element_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitWork>(
      create: (context) => CubitWork(stateMain.zshiftsDistributionList,  stateMain.machineIdList ?? [], stateMain.user!.id),
      child: BlocProvider<CubitTimer>(
        create: (context) => CubitTimer(context.read<CubitWork>().state.timeActive, context.read<CubitWork>().state.listStartTime),
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
            title: const Text('Монитор операций'),
          ),
          body: BlocListener<CubitWork,StateWork>(
            listener: (innerContext, state) {
              if (state.exit) {Navigator.pop(context);}
            },
            child: const SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child:  ElementBarOperator(),
                ),
              ),
            ),
          )),
    );
  }
}

