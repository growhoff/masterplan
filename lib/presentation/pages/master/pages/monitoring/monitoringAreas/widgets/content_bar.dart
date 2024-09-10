import 'package:flutter/material.dart';
import '../widgets/element_bar.dart';

class MonitoringPageContentArea extends StatelessWidget {
  const MonitoringPageContentArea({super.key});
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