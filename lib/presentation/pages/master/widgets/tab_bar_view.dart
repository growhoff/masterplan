import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/distribution_machine_page.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoring_page.dart';
import '../maste_page.dart';

class TabBarViewCustom extends StatelessWidget {
  const TabBarViewCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return const TabBarView (
            children: [
            PageOne(),
            PageMonitor(),
            PageDetail(),
            PageTest('3'),
            PageTest('4'),
            PageTest('5'),
          ]);
  }
}

class PageTest extends StatelessWidget {
  const PageTest(this.text,{super.key});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(child: Text(text),);
  }
}