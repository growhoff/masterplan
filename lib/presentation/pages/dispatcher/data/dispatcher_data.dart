import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/orders_page.dart';
import 'package:master_plan/presentation/pages/dispatcher/queue_stages_page/queue_stages_page.dart';
import 'package:master_plan/presentation/pages/dispatcher/ready_orders_page/ready_orders_page.dart';

import '../../../widgets/in_development_page.dart';
import '../../chief/model/tab_bar_model.dart';
import '../dispatcher_analytics_page/dispatcher_analytics_page.dart';
import '../distribution_page/dispatcher_distribution_page.dart';
import '../lists_page/lists_page.dart';
import '../orders_page/batches_page/batches_cubit/batches_cubit.dart';

abstract class DispatcherData {
  static List<TabBarModel> listPage = [
    TabBarModel(
        title: 'Списки предприятия',
        actions: [],
        page: const DispatcherListsPage(),
        icon: Icons.list),
    TabBarModel(
        title: 'Заказы на производство',
        actions: [
          BlocProvider(
            create: (context) => BatchesCubit(false,'1'),
            child: IconButton(
                onPressed: () {
                  BatchesCubit(false,'1').loadOrder();
                },
                icon: const Icon(Icons.download)),
          ),
          Builder(builder: (context) {
            return IconButton(
              icon: const Icon(Icons.add_rounded),
              onPressed: () {
                Navigator.pushNamed(context, '/addOrderPage');
              },
            );
          }),
        ],
        page: const OrdersPage(),
        icon: Icons.all_inbox_rounded),
    TabBarModel(
        title: 'Распределение этапов',
        actions: [],
        page: const DispatcherDistributionPage(),
        icon: Icons.lan),
    TabBarModel(
        title: 'Очередь этапов',
        actions: [],
        page: const QueueStagesPage(),
        icon: Icons.library_add),
    TabBarModel(
        title: 'Задания на производстве',
        actions: [],
        page: const InDevelopmentPage(),
        icon: Icons.task_rounded),
    TabBarModel(
        title: 'Отбракованные детали',
        actions: [],
        page: const InDevelopmentPage(),
        icon: Icons.broken_image),
    TabBarModel(
        title: 'Готовые заказы',
        actions: [],
        page: ReadyOrdersPage(),
        icon: Icons.check_box),
    TabBarModel(
        title: 'Аналитика',
        actions: [],
        page: const DispatcherAnalyticsPage(),
        icon: Icons.fact_check_sharp),

  ];
}
