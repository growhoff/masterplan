import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/model/item_machine_monitor.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/widgets/element_bar.dart';
import './widgets/calendar.dart';
import 'widgets/status_item.dart';
import 'widgets/status_line.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final stateMain = context.read<CubitMain>().state;
    return BlocProvider<CubitMonitoring>(
      create: (context) => CubitMonitoring(stateMain.machineList,  stateMain.machineIdList!),
      child: const MonitoringPageContent(),
    );
  }
}


class MonitoringPageContent extends StatelessWidget {
  const MonitoringPageContent({super.key});
  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: ElementBarMonitor(),
        ),
      ),
    );
  }
}

class ContentListWidgetMaster extends StatelessWidget {
  const ContentListWidgetMaster(this.monitor, this.changeId, {super.key});
  final ItemMachineMonitorMaster monitor;
  final int changeId;
  @override
  Widget build(BuildContext context) {
    List<ItemMachineStatus> listStatus = [];
    for (var element in monitor.listStatus) {
      if (element.changeId == changeId) listStatus.add(element);
    }
    return Column(
      children: [
        Text('${monitor.machine.name} станок', textAlign: TextAlign.left),
        const SizedBox(height: 8),
        const Card(child: Calendar()),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            BlocBuilder<CubitMonitoring, StateMonitoring>(builder: (context, state) => Expanded(flex: 5, child: ElevatedButton(onPressed: () => context.read<CubitMonitoring>().setChange(1), style: ElevatedButton.styleFrom(backgroundColor: state.change == 1 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('1 смена')))),
            const Spacer(),
            BlocBuilder<CubitMonitoring, StateMonitoring>(builder: (context, state) => Expanded(flex: 5,child: ElevatedButton(onPressed: () => context.read<CubitMonitoring>().setChange(2), style: ElevatedButton.styleFrom(backgroundColor: state.change == 2 ? Colors.blue : Colors.blueGrey, padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 5)), child: const Text('2 смена'))))
          ],
        ),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
      StatusLine(listStatus),
      const SizedBox(height: 8),
      const Divider(),
      const SizedBox(height: 8),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 4, child: Text('Статус')),
            Expanded(flex: 2,child: Text('Начало')),
            Expanded(flex: 2,child: Text('Конец')),
            Expanded(flex: 2,child: Text('Общее')),
            Expanded(child: Text('%')),
          ],
        ),
        const SizedBox(height: 8),
        listStatus.isEmpty 
        ? const Center(child: Text('Список пуст')) 
        : ListView.separated(
            shrinkWrap: true,
            itemCount: listStatus.length,
            itemBuilder: (context, index) => StatusItem(item: listStatus[index], allTime: monitor.allTime),
            separatorBuilder: (context, index) => const SizedBox(height: 3),
          )
      ],
    );
  }
}