import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/bloc/cubit.dart';

class TextError extends StatelessWidget {
  const TextError({super.key});

  @override
  Widget build(BuildContext context) {
    final machineList = context.read<CubitOperator>().machineIdList;
    return Visibility(
        visible: machineList.isEmpty,
        child: const Card(color: Colors.red, child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Text('Отсутствует оборудование, обратитесь к мастеру!!!'),
        )));
  }
}
