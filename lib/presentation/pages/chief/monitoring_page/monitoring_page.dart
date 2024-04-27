import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

import 'package:intl/intl.dart';

import '../widgets/element_bar_widget.dart';
import 'model/item_machine.dart';
import 'model/item_machine_monitor.dart';
import 'monitoring_cubit/monitoring_cubit.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MonitoringCubit>(
      create: (context) => MonitoringCubit(),
      child: const MonitoringPageContent(),
    );
  }
}

class MonitoringPageContent extends StatefulWidget {
  const MonitoringPageContent({super.key});

  @override
  State<MonitoringPageContent> createState() => _MonitoringPageContentState();
}

class _MonitoringPageContentState extends State<MonitoringPageContent> {
  @override
  void initState() {
   context.read<MonitoringCubit>().fetchElementBars();
    //context.read<MonitoringCubit>().fetch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<MonitoringCubit, MonitoringState>(
        builder: (context, state) {
          if (state.listBar != []) {
            return SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ElementBar(list: state.listBar!),
                    ],
                  )),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ContentListWidget extends StatelessWidget {
  const ContentListWidget({required this.monitor, super.key});

  final ItemMachineMonitor monitor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Text('${monitor.machine.name} станок',
                    textAlign: TextAlign.left)),
            Expanded(
                child: Text(
                    'дата: ${DateFormat('dd.MM.yyyy').format(DateTime.now())}',
                    textAlign: TextAlign.center)),
            const Expanded(child: Text('смена: 1', textAlign: TextAlign.right))
          ],
        ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        StatusLine(monitor.listStatus),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        // const Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(flex: 4, child: Text('Статус')),
        //     Expanded(flex: 2, child: Text('Начало')),
        //     Expanded(flex: 2, child: Text('Конец')),
        //     Expanded(flex: 2, child: Text('Общее')),
        //     Expanded(child: Text('%')),
        //   ],
        // ),
        // const SizedBox(height: 8),
        // ListView.separated(
        //   shrinkWrap: true,
        //   itemCount: monitor.listStatus.length,
        //   itemBuilder: (context, index) => StatusItem(
        //       item: monitor.listStatus[index], allTime: monitor.allTime),
        //   separatorBuilder: (context, index) => const SizedBox(height: 3),
        // )
      ],
    );
  }
}

class StatusItem extends StatelessWidget {
  const StatusItem({super.key, required this.item, required this.allTime});

  final ItemMachineStatus item;
  final int allTime;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        Container(
                          color: convertColor(item.status.id),
                          width: 10,
                          height: 10,
                        ),
                        const SizedBox(width: 5),
                        Text(item.status.name)
                      ],
                    )),
                Expanded(flex: 2, child: Text(convertTime(item.timeStart))),
                Expanded(flex: 2, child: Text(convertTime(item.timeEnd))),
                Expanded(flex: 2, child: Text(convertTime(item.timeWorking))),
                Expanded(
                    child: Text(
                        '${((item.timeWorking / allTime) * 100).round()}%')),
              ],
            ),
            const SizedBox(height: 8),
            Text(item.comment),
          ],
        ),
      ),
    );
  }
}

class StatusLine extends StatelessWidget {
  const StatusLine(this.list, {super.key});

  final List<ItemMachineStatus> list;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: Row(
        children: list
            .map((e) => Expanded(
                flex: e.timeWorking,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black),
                        color: convertColor(e.status.id)))))
            .toList(),
      ),
    );
  }
}

String convertTime(int time) {
  final h = time ~/ 60;
  final min = time - h * 60;
  final minStr = min > 9 ? '$min' : '0$min';
  final hStr = h > 9 ? '$h' : '0$h';
  return '$hStr:$minStr';
}

Color convertColor(int status) {
  Color colorStatus;
  switch (status) {
    case 1:
      colorStatus = Colors.green;
    case 2:
      colorStatus = Colors.yellow;
    case 3:
      colorStatus = Colors.red;
    case 4:
      colorStatus = Colors.orange;
    case 5:
      colorStatus = Colors.purple;
    case 6:
      colorStatus = Colors.blue;
    case 7:
      colorStatus = Colors.grey;
    case 8:
      colorStatus = Colors.white;
      break;
    default:
      colorStatus = Colors.white;
  }
  return colorStatus;
}
