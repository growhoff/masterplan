import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/widgets/data_list.dart';
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
            title: const Text('Отправка на станок'),
            // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
          ),
          bottomNavigationBar: const BottomAppBarCastom(),
          body: const TabBarViewCustom()
        ),
      ),
    );
  }
}

class PageDetail extends StatelessWidget {
  const PageDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              
            //  ListView.builder(
            //   shrinkWrap: true,
            //   itemCount: 5,
            //   itemBuilder: (context, index) => CheckItem(index),
            //  ),

            //DataTable как альтернатива
             const DataList(),
             const SizedBox(height: 8),
             SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(onPressed: (){}, child: const Text('Отправить на распределение')))
            ],
          )
        ),
      ),
    );
  }
}