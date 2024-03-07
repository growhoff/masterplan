import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_analytics_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_check_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page.dart';
import 'package:master_plan/presentation/pages/chief/chief_monitoring_page.dart';

import '../chief_model/tab_bar_model.dart';
import '../chief_page.dart';

abstract class DataMaster {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки',
        actions: [],
        page: const ChiefPage(),
        icon: Icons.personal_video),
    TabBarModel(
        title: 'Проверка',
        actions: [],
        page: const ChiefCheckPage(),
        icon: Icons.browser_updated),
    TabBarModel(
        title: 'Распределение',
        actions: [],
        page: const ChiefDistributionPage(),
        icon: Icons.lan),
    TabBarModel(
        title: 'Мониторинг',
        actions: [],
        page: const ChiefMonitoringPage(),
        icon: Icons.library_add),
    TabBarModel(
        title: 'Аналитика',
        actions: [],
        page: const ChiefAnalyticsPage(),
        icon: Icons.check_box),
  ];
// actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
}
