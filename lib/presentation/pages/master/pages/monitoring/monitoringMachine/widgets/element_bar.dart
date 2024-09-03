import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import './drop_area.dart';
import './drop_machine.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
import 'content_monitoring.dart';

class ElementBarMonitor extends StatelessWidget {
  const ElementBarMonitor({super.key});
  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    bool oneArea = stateMain.user!.positionId == 3;
    return BlocBuilder<CubitMonitoringMachine, StateMonitoringMachine>(
      builder:(context, state) => 
      state.listItemMachine.isNotEmpty
      ? Column(
        children: [
            Visibility(
              visible: !oneArea,
              child: DropArea(state.activeArea, state.listItemArea),
            ),
            const SizedBox(height: 8),
            DropMachine(state.activeMachine, state.listItemMachine),
            const SizedBox(height: 18),
            state.listMonitor!.isNotEmpty
            ? state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ContentListWidgetMaster(state.listMonitor![state.activeMachine], state.change, state.listStatusActive, state.statusActive!)
            : const Center(child: Text('Пусто'))
        ],
      )
      : const Center(child: Text('Нет станков')),
    );
  }
}