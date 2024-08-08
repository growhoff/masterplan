import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import './../bloc/cubit.dart';
import './../bloc/state.dart';


class ButtonChangeOper extends StatelessWidget {
  const ButtonChangeOper(this.change, {super.key});
  final int change;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitChangeOperator, StateCubitChangeOperator>(
        builder: (context, state) => Expanded(
            flex: 5,
            child: ElevatedButton(
                onPressed: () => context.read<CubitChangeOperator>().setChange(change),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        state.change == change ? const Color.fromARGB(255, 155, 235, 157) : const Color.fromARGB(255, 185, 208, 219),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 5)),
                child: Text('$change смена', style: const TextStyle(color: Colors.black),))));
  }
}
                      