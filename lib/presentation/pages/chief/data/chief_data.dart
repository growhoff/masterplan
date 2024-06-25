import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/monitoring/monitoring_page.dart';
// import 'package:master_plan/presentation/pages/chief/statistics_page/statistics_page.dart';

import 'package:master_plan/presentation/pages/chief/operations_distribution_page/distribution_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_lists_page.dart';
import 'package:master_plan/presentation/pages/chief/queue_operations/queue_operations_page.dart';
// import 'package:master_plan/presentation/pages/chief/monitoring_page.dart';

import '../model/tab_bar_model.dart';
// import '../monitoring_page/monitoring_page.dart';
import '../statistics_page/choose_report_page.dart';

abstract class DataChief {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки цеха',
        actions: [],
        page: const ChiefListsPage(),
        icon: Icons.list),
    TabBarModel(
        title: 'Распределение операций',
        actions: [],
        page: const ChiefDistributionPage(),
        icon: Icons.lan),
    TabBarModel(
        title: 'Очередь операций',
        actions: [],
        page: const QueueOperatPageMasterChief(),
        icon: Icons.queue),
   TabBarModel(
        title: 'Мониторинг',
        actions: [],
        page: const MonitoringPageChief(),
        icon: Icons.camera_alt_outlined),
    TabBarModel(
        title: 'Аналитика',
        actions: [],
        page: const ChooseReportPage(),
        icon: Icons.stacked_bar_chart_sharp),
  ];
}
