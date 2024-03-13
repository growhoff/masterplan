import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/maste_page.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/model/tab_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/distribution_details_page.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/distribution_machine_page.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoring_page.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/ready_details.dart';

abstract class DataMaster {
  static List<TabBarData> listPage = [
    TabBarData(
        title: 'Список смен',
        actions: [
          Tooltip(
            message: 'Закрепить все',
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.auto_fix_high),
            ),
          ),
          Tooltip(
            message: 'Открепить все',
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.auto_fix_off),
            ),
          )
        ],
        page: const MasterPage(),
        icon: Icons.graphic_eq),
    TabBarData(
        title: 'Отправка на станок',
        actions: [],
        page: const DetailPage(),
        icon: Icons.browser_updated),
    TabBarData(
        title: 'Распределение деталей',
        actions: [],
        page: const DetailDistribPage(),
        icon: Icons.lan),
    TabBarData(
        title: 'Очередь',
        actions: [],
        page: const QueuePageMaster(),
        icon: Icons.library_add),
    TabBarData(
        title: 'Готовые детали',
        actions: [],
        page: const ReadyDetailsPage(),
        icon: Icons.check_box),
    TabBarData(
        title: 'Мониторинг участка',
        actions: [],
        page: const MonitoringPage(),
        icon: Icons.personal_video),
  ];
  // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],

  static List<ElementBarData> listElementBar = [
    ElementBarData(header: 'Станок', content: const ContetnReady('Станок')),
    ElementBarData(header: 'Фрезер', content: const ContetnReady('Фрезер')),
    ElementBarData(header: 'Шлиф', content: const ContetnReady('Шлиф')),
  ];

  static List<ElementBarData> listElementBarQueue = [
    ElementBarData(header: 'Станок', content: const ContetnQueue('Станок')),
    ElementBarData(header: 'Фрезер', content: const ContetnQueue('Фрезер')),
    ElementBarData(header: 'Шлиф', content: const ContetnQueue('Шлиф')),
  ];
}
