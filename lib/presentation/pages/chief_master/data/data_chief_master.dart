import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_page.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/chief_lists_pages/chief_lists_page.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/distribution/distribution_page.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/monitoring/monitoring_page.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/chief_master/pages/ready/ready_page.dart';
import '../model/tab_bar_data.dart';
import '../pages/analytics_page/analytics_page.dart';

abstract class DataChiefMaster {
  static List<TabBarDataChiefMaster> listPage = [
    TabBarDataChiefMaster(
        title: 'Списки цеха',
        actions: [],
        page: const ChiefListsPageChM(),
        icon: Icons.graphic_eq),
    TabBarDataChiefMaster(
        title: 'Этапы в цехе',
        actions: [],
        page: const StagesInUnitPage(),
        icon: Icons.auto_awesome_mosaic_rounded),
    TabBarDataChiefMaster(
        title: 'Распределение операций/деталей',
        actions: [],
        page: const DistributionPage(),
        icon: Icons.lan),
    TabBarDataChiefMaster(
        title: 'Очередь операций и деталей',
        actions: [],
        page: const QueuePage(),
        icon: Icons.library_add),
    TabBarDataChiefMaster(
        title: 'Готовые этапы и детали',
        actions: [],
        page: const ReadyPage(),
        icon: Icons.check_box),
    TabBarDataChiefMaster(
        title: 'Аналитика',
        actions: [],
        page: const AnalyticsPageChM(),
        icon: Icons.fact_check_sharp),
    TabBarDataChiefMaster(
        title: 'Мониторинг цеха и участков',
        actions: [],
        page: const MonitoringPageChM(),
        icon: Icons.personal_video),
  ];
}
