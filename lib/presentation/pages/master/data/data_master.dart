// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/model/tab_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/brakDetails/brak_details_page.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/change_oper_page.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/distribution_details_page.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoring_page.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/ready_details.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/stage_area_page.dart';

import '../pages/analytics_page/analytics_page.dart';

abstract class DataMaster {
  static List<TabBarData> listPage = [
    TabBarData(
        title: 'Список смен',
        actions: [],
        page: const ChangeOperatorPage(),
        icon: Icons.graphic_eq),
    TabBarData(
        title: 'Распределение деталей',
        actions: [],
        page: const DetailDistribPage(),
        icon: Icons.lan),
    TabBarData(
        title: 'Очередь деталей',
        actions: [],
        page: const QueuePageMaster(),
        icon: Icons.library_add),
    TabBarData(
        title: 'Готовые детали',
        actions: [],
        page: const BrakReadyDetailsPage(),
        icon: Icons.check_box),
    TabBarData(
        title: 'Отбракованные детали',
        actions: [],
        page: const BrakDetailsPage(),
        icon: Icons.bookmark_remove),
    TabBarData(
        title: 'Мониторинг участка',
        actions: [],
        page: const MonitoringPage(),
        icon: Icons.personal_video),
    TabBarData(
        title: 'Аналитика',
        actions: [],
        page: const AnalyticsPage(),
        icon: Icons.fact_check_sharp),
    TabBarData(
        title: 'Этапы на участке',
        actions: [],
        page: const StageOnAreaPage(),
        icon: Icons.settings_accessibility_sharp),
  ];
}
