import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChiefMonitoringComponent extends StatefulWidget {
  const ChiefMonitoringComponent({super.key});

  @override
  State<ChiefMonitoringComponent> createState() =>
      _ChiefMonitoringComponentState();
}

class _ChiefMonitoringComponentState extends State<ChiefMonitoringComponent> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 25,
        child: Row(
          children: monitoringList,
        ));
  }
}

class MonitoringContainer extends StatelessWidget {
  const MonitoringContainer({super.key, required this.time, this.color});

  final int time;
  final MaterialColor? color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: time,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.black), color: color),
      ),
    );
  }
}

List<MonitoringContainer> monitoringList = [
  MonitoringContainer(time: 1, color: Colors.red),
  MonitoringContainer(time: 3, color: Colors.green),
  MonitoringContainer(time: 2, color: Colors.blue),
];
