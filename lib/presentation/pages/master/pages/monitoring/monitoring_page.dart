import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';
import 'package:master_plan/presentation/pages/master/widgets/bottom_app_bar.dart';
import 'package:master_plan/presentation/pages/master/widgets/tab_bar_view.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class MonitoringPage extends StatelessWidget {
  const MonitoringPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentMonitoring();
  }
}

class ContentMonitoring extends StatelessWidget {
  const ContentMonitoring({super.key});
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: DataMaster.tabs.length,
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Мониторинг участка'),
            // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
          ),
          bottomNavigationBar: const BottomAppBarCastom(),
          body: const TabBarViewCustom()
        ),
      ),
    );
  }
}

class PageMonitor extends StatelessWidget {
  const PageMonitor({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: 5,
          itemBuilder: (context, index) => ContentListWidget(index: index),)
      ),
    );
  }
}

class ContentListWidget extends StatelessWidget {
  const ContentListWidget({
    super.key,
    required this.index
  });
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black12,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               Text('equipmentName $index'),
               const Icon(Icons.hail_sharp)
             ],
           ),
           const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Деталь')),
                Expanded(child: Text('planNumber')),
                Expanded(child: Text('Время в работе'))
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text('Операция')),
                Expanded(child: Text('operationName')),
                Expanded(child: Text('workingTime'))
              ],
            ),
            const SizedBox(height: 8),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Загрузка станк'),
                Text('minutesConverter')
              ],
            )
          ],
        ),
      ),
    );
  }
}