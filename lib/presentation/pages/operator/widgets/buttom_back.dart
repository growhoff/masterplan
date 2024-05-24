import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/bloc/state.dart';

class ButtomBack extends StatelessWidget {
  const ButtomBack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitOperator, StateOperator>(builder: (context, state) => Visibility(visible: state.isStart ,child: ElevatedButton(onPressed: ()=> Navigator.pushNamed(context, '/workPage'), child: const Text('Вернуться'))));
  }
}