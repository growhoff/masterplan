import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_page.dart';


import '../../chief/model/tab_bar_model.dart';
import '../distribution_page/dispatcher_distribution_page.dart';
import '../lists_page/lists_page.dart';

abstract class DispatcherData {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки предприятия',
        actions: [],
        page:  const DispatcherListsPage(),
        icon: Icons.list),
    TabBarModel(
        title: 'Заказы на производство',
        actions: [],
        page:  const OrdersPage(),
        icon: Icons.all_inbox_rounded),
     TabBarModel(
        title: 'Распределение этапов',
        actions: [],
        page: DispatcherDistributionPage(),
        icon:  Icons.lan),
    TabBarModel(
        title: 'Очередь заказов',
        actions: [],
        page:  Container(),
        icon: Icons.library_add),
    TabBarModel(
        title: 'Готовые заказы',
        actions: [],
        page:  Container(),
        icon: Icons.check_box),
    TabBarModel(
        title: 'Аналитика',
        actions: [],
        page:  Container(),
        icon: Icons.fact_check_sharp),
  ];
}
