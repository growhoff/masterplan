import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_analytics_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_check_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_monitoring_page.dart';

import '../chief_model/tab_bar_model.dart';
import '../chief_page.dart';

abstract class DataChief {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки',
        actions: [],
        page: const ChiefPage(),
        icon: Icons.list),
    TabBarModel(
        title: 'Проверка',
        actions: [],
        page: const ChiefCheckPage(),
        icon: Icons.home_outlined),
    TabBarModel(
        title: 'Распределение',
        actions: [],
        page: const ChiefDistributionPage(),
        icon: Icons.lan),
    TabBarModel(
        title: 'Мониторинг',
        actions: [],
        page: const ChiefMonitoringPage(),
        icon: Icons.camera_alt_outlined),
    TabBarModel(
        title: 'Аналитика',
        actions: [],
        page: const ChiefAnalyticsPage(),
        icon: Icons.stacked_bar_chart_sharp),
  ];
// actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
}
