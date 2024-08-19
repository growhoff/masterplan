import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/widgets/text_error.dart';
import 'widgets/buttom_back.dart';
import 'widgets/buttom_start.dart';


class OperatorPage extends StatelessWidget {
  const OperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitOperator>(
      create: (context) => CubitOperator(stateMain.user!.id, stateMain.machineIdList!, stateMain.change!),
      child: const ContentOperator()
    );
  }
}

class ContentOperator extends StatelessWidget {
  const ContentOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
            return Column(
            children: [
              const Text('Оператор'),
              Text('${state.user!.fio} / ${state.user!.position.name} / ${state.change} смена', style: const TextStyle(fontSize: 12)),
            ]);
            }),
          actions: const [],
        ),
        body:  const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextError(),
                  SizedBox(height: 16),
                  ButtomStart(),
                  SizedBox(height: 16),
                  ButtomBack(),
                  // const SizedBox(height: 8),
                  // ElevatedButton(onPressed: (){}, child: const Text('Календарь смен')),
                  // const SizedBox(height: 8),
                  // ElevatedButton(onPressed: (){}, child: const Text('Очередь деталей')),
                ],
              ),
            )
            ),
        ),
      ),
    );
  }
}