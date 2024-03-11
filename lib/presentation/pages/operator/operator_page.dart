import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';


class OperatorPage extends StatelessWidget {
  const OperatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentOperator();
  }
}

class ContentOperator extends StatelessWidget {
  const ContentOperator({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) => Column(
            children: [
              const Text('Оператор'),
              Text('${state.user.id} / ${state.user.fio} / ${state.user.position} / ${state.user.region}', style: const TextStyle(fontSize: 12)),
            ])),
          actions: const [],
        ),
        body:  SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const ButtonCustom(),
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

class ButtonCustom extends StatefulWidget {
  const ButtonCustom({super.key});

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {

  bool isStart = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (!isStart) Navigator.pushNamed(context, '/workPage');
        isStart = !isStart;
        setState(() {});
        
      }, 
      child: Text(!isStart ? 'Начать смену' : 'Закончить смену'),
    );
  }
}