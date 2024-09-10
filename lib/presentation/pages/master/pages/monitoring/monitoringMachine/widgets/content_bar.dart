import 'package:flutter/material.dart';
import 'element_bar.dart';

class MonitoringPageContentMachine extends StatelessWidget {
  const MonitoringPageContentMachine({super.key});
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
        thickness: 10,
        thumbVisibility: true,
        radius: const Radius.circular(10),
      child: ListView(
        children: const [SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: ElementBarMonitor(),
          ),
        )],
      ),
    );
  }
}