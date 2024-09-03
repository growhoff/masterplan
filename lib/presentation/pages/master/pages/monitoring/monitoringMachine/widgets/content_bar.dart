import 'package:flutter/material.dart';
import 'element_bar.dart';

class MonitoringPageContentMachine extends StatelessWidget {
  const MonitoringPageContentMachine({super.key});
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