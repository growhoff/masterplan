import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'drop_area.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
import 'content_monitoring.dart';

class ElementBarMonitor extends StatelessWidget {
  const ElementBarMonitor({super.key});
  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    bool oneArea = stateMain.user!.positionId == 3;
    return BlocBuilder<CubitMonitoringAreas, StateMonitoringAreas>(
      builder:(context, state) => 
      state.listItemMachine.isNotEmpty
      ? Column(
        children: [
            Visibility(
              visible: !oneArea,
              child: DropArea(state.activeArea, state.listItemArea),
            ),
            Visibility(
              visible: oneArea,
              child: Text(state.listItemArea[state.activeArea].name),
            ),
            const SizedBox(height: 18),
            state.listMonitor!.isNotEmpty
            ? state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ContentListWidgetMaster(state.change, state.listStatusActiveNew, state.statusActiveList!, state.maxChange)
            : const Center(child: Text('Пусто'))
        ],
      )
      : const Center(child: Text('Нет станков')),
    );
  }
}