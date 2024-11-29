
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/pages/analytics_page/analytics_page.dart';
import 'package:master_plan/presentation/pages/master/pages/brakDetails/brak_details_page.dart';
import 'package:master_plan/presentation/pages/master/pages/changeOperator/change_oper_page.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionDetails/distribution_details_page.dart';
import 'package:master_plan/presentation/pages/master/pages/monitoring/monitoring_page.dart';
import 'package:master_plan/presentation/pages/master/pages/queue/queue_page.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/ready_details.dart';
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/stage_area_page.dart';

class CardGrid extends StatelessWidget {
  const CardGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CubitMain, StateMain>(builder: (context, state){
            final user = state.user!;
            return Column(children: [
              const Text('Мастер'), 
              Text('${user.fio} / ${user.unit!.name} /\n${user.area!.name}', style: const TextStyle(fontSize: 12), textAlign: TextAlign.center,),
            ]);
            }
          ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: LayoutBuilder(
          builder: (ctx, constraints) => GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: constraints.maxWidth < 800 ? 2 : constraints.maxWidth < 1200 ? 3 : 4,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1.5,
            ),
            scrollDirection: Axis.vertical,
            children: [
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeOperatorPage())), text: 'Распределение сотрудников на оборудование'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DetailDistribPage())), text: 'Распределение деталей'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const QueuePageMaster())), text: 'Очередь деталей на станках'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BrakReadyDetailsPage())), text: 'Готовые детали'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BrakDetailsPage())), text: 'Отбракованные детали  оператором'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StageOnAreaPage())), text: 'Этапы на участке (просмотр)'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsPage())), text: 'Аналитика'),
              ButtonCustomMasterStart(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MonitoringPage())), text: 'Мониторинг'),
            ],
          ),
        ),
      ),
    );
  }
}


class ButtonCustomMasterStart extends StatelessWidget {
  const ButtonCustomMasterStart({super.key, required this.onPressed, required this.text});
  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: onPressed, style: ButtonStyle(padding: WidgetStateProperty.all(const EdgeInsets.all(16))), child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black),));
  }
}