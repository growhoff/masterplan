import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_analytics_page/analytics_page.dart';
import 'package:master_plan/presentation/pages/chief/monitoring/monitoring_page.dart';

import 'package:master_plan/presentation/pages/chief/chief_lists_pages/chief_lists_page.dart';
import 'package:master_plan/presentation/pages/chief/queue_operations/queue_operations_page.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_page.dart';

import '../model/tab_bar_model.dart';

import '../operations_distribution_page/chief_distribution_page.dart';
import '../reports_page/choose_report_page.dart';

abstract class DataChief {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки цеха',
        actions: [],
        page: const ChiefListsPage(),
        icon: Icons.list),
    TabBarModel(
        title: 'этапы в цехе',
        actions: [],
        page: const StagesInUnitPage(),
        icon:  Icons.auto_awesome_mosaic_rounded),
    // TabBarModel(
    //     title: 'Этапы в цехе',
    //     actions: [],
    //     page: const ChiefAnalyticsPage(),
    //     icon: Icons.auto_awesome_mosaic_rounded),
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
        title: 'Аналитика',
        actions: [],
        page: const ChooseReportPage(),
        icon: Icons.analytics_rounded),
    TabBarModel(
        title: 'Мониторинг цеха',
        actions: [],
        page: const MonitoringPageChief(),
        icon: Icons.camera_alt_outlined),
    // TabBarModel(
    //     title: 'новое распределение',
    //     actions: [],
    //     page: const MonitoringPageChief(),
    //     icon: Icons.camera_alt_outlined),

  ];
}
