import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/widgets/drop_area.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/widgets/drop_machine.dart';
import '../../monitoring/bloc/cubit.dart';
import '../../monitoring/bloc/state.dart';
import 'content_monitoring.dart';

class ElementBarMonitor extends StatelessWidget {
  const ElementBarMonitor(this.oneArea, {super.key});
  final bool oneArea;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitMonitoring, StateMonitoring>(
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
            ? ContentListWidgetMaster(state.listMonitor![state.activeMachine], state.change, state.listStatusActive, state.statusActive!)
            : const Center(child: CircularProgressIndicator())
        ],
      )
      : const Center(child: Text('Нет станков')),
    );
  }
}