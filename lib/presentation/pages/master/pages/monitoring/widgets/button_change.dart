import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../monitoring/bloc/cubit.dart';
import '../../monitoring/bloc/state.dart';


class ButtonChange extends StatelessWidget {
  const ButtonChange(this.change, {super.key});
  final int change;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMonitoring, StateMonitoring>(
        builder: (context, state) => Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: ElevatedButton(
                onPressed: () => context.read<CubitMonitoring>().setChange(change),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        state.change == change ? const Color.fromARGB(255, 155, 235, 157) : const Color.fromARGB(255, 185, 208, 219),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 5)),
                child: Text('$change смена', style: const TextStyle(color: Colors.black),)),
          ),
        ));
  }
}
