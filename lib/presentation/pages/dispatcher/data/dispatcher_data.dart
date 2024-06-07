import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_page.dart';


import '../../chief/model/tab_bar_model.dart';

abstract class DispatcherData {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки предприятия',
        actions: [],
        page:  Container(),
        icon: Icons.list),
    TabBarModel(
        title: 'Заказы на производство',
        actions: [],
        page:  OrdersPage(),
        icon: Icons.all_inbox_rounded),
     TabBarModel(
        title: 'Распределение этапов',
        actions: [],
        page: Container(),
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
