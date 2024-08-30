import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringMachine/widgets/dialog_job.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringMachine/widgets/drop_area.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringMachine/widgets/drop_machine.dart';
// import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoringAreas/monitoring_area_page.dart';
import '../bloc/cubit.dart';
import '../bloc/state.dart';
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
            // ElevatedButton(
            //   onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringAreasPage(),)), 
            //   child: const Icon(Icons.change_circle)),
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