import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/state.dart';


class OperatorPage extends StatelessWidget {
  const OperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitOperator>(
      create: (context) => CubitOperator(),
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
            final user = state.user!;
            return Column(
            children: [
              const Text('Оператор'),
              Text('${user.fio} / ${user.position.name}', style: const TextStyle(fontSize: 12)),
            ]);
            }),
          actions: const [],
        ),
        body:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ButtomStart(),
                  const SizedBox(height: 16),
                  const ButtomBack(),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: (){}, child: const Text('Календарь смен')),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: (){}, child: const Text('Очередь деталей')),
                ],
              ),
            )
            ),
        ),
      ),
    );
  }
}

class ButtomBack extends StatelessWidget {
  const ButtomBack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitOperator, StateOperator>(builder: (context, state) => Visibility(visible: state.isStart ,child: ElevatedButton(onPressed: ()=> Navigator.pushNamed(context, '/workPage'), child: const Text('Вернуться'))));
  }
}

class ButtomStart extends StatelessWidget {
  const ButtomStart({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMain, StateMain>(
      builder: (context, state2) => BlocBuilder<CubitOperator, StateOperator>(
            builder: (context, state) => ElevatedButton(
                  onPressed: () {
                    if (!state.isStart && state2.zshiftsDistributionList != null) {
                      Navigator.pushNamed(context, '/workPage');
                    }
                    context.read<CubitOperator>().toggleBtn(state2.user!.id);
                  },
                  child: Text(!state.isStart ? 'Начать смену' : 'Закончить смену'),
                )),
    );
  }
}