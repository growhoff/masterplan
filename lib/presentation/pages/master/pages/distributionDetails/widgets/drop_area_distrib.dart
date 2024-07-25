import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/bloc/state.dart';

class DropAreaDistrib extends StatelessWidget {
  const DropAreaDistrib({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitDistributionDetails, StateDistributionDetails>(
      builder: (context, state)  => Visibility(
        visible: state.listAreaMachine.length > 1,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButton<int>(
            isExpanded: true,
            underline: Container(),
            borderRadius: BorderRadius.circular(12),
            hint: const Text('Выберите участок'),
            value: state.activeArea,
            items: state.listItemArea.map((e) => DropdownMenuItem(value: e.index, child: Text(e.name))).toList(),
            selectedItemBuilder: (context) =>
                state.listItemArea.map((e) => Center(child: Text(e.name))).toList(),
            onChanged: (value) => value != null
                ? context.read<CubitDistributionDetails>().setActiveArea(value)
                : null,
          ),
        ),
      ),
    );
  }
}
