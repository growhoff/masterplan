import 'package:flutter/material.dart';
import 'widgets/elevated_button_castom.dart';
import 'widgets/line_text_spawn.dart';
import 'widgets/timer.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentWork();
  }
}

class ContentWork extends StatelessWidget {
  const ContentWork({super.key});

  static const List<Widget> tabs = [
    Tab(text: 'Станок1'),
    Tab(text: 'Станок2'),
    Tab(text: 'Станок3'),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Оператор'),
            // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
            bottom: const TabBar(tabs: tabs),
          ),
          body: const TabBarView(
            children: [
            PageDetail(detal: 'Станок1', operation: 'Klu'),
            PageDetail(detal: 'Станок2', operation: 'Prty'),
            PageDetail(detal: 'Станок3', operation: 'Sgrek'),
          ]),
        ),
      ),
    );
  }
}

class PageDetail extends StatelessWidget {
  const PageDetail({super.key, required this.detal,required this.operation });
  final String detal;
  final String operation;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            LineTextSpawn(title: 'Деталь', text: detal),
            const SizedBox(height: 8),
            LineTextSpawn(title: 'Операция', text: operation),
            const SizedBox(height: 8),
            const TimerWidget(),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: (){}, child: const Text('Начать работу')),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButtonCastom(text: 'Переналадка', color: Colors.amber, onPressed: (){},),
                ElevatedButtonCastom(text: 'Уборка', color: Colors.blueGrey, onPressed: (){},),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButtonCastom(text: 'Деталь', color: Colors.green, onPressed: (){},),
            const SizedBox(height: 8),
            ElevatedButtonCastom(text: 'Поломка', color: Colors.red, onPressed: (){},)
          ],
        )
      ),
    );
  }
}