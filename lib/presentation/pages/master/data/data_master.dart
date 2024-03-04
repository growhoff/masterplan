import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/maste_page.dart';
import 'package:master_plan/presentation/pages/master/model/tab_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/distribution_machine_page.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoring_page.dart';

abstract class DataMaster{

  static List<TabBarData> listPage = [
    TabBarData(
      title: 'Master Список смен',
      actions: [
              Tooltip(
                message: 'Закрепить все',
                child: IconButton(onPressed: (){
                }, icon: const Icon(Icons.auto_fix_high),),
              ),
              Tooltip(
                message: 'Открепить все',
                child: IconButton(onPressed: (){
                }, icon: const Icon(Icons.auto_fix_off),),
              )
            ],
      page: const MasterPage(),
      icon: Icons.laptop_windows
    ),
    TabBarData(
      title: 'Мониторинг участка',
      actions: [],
      page: const MonitoringPage(),
      icon: Icons.last_page
    ),
    TabBarData(
      title: 'Отправка на станок',
      actions: [],
      page: const DetailPage(),
      icon: Icons.schema
    ),
  ];
}