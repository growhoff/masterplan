import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/state.dart';


class ButtonChange extends StatelessWidget {
  const ButtonChange(this.change, {super.key});
  final int change;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMonitoring, StateMonitoring>(
        builder: (context, state) => Expanded(
            flex: 5,
            child: ElevatedButton(
                onPressed: () => context.read<CubitMonitoring>().setChange(change),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                        state.change == change ? Colors.blue : Colors.blueGrey,
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 5)),
                child: Text('$change смена'))));
  }
}
