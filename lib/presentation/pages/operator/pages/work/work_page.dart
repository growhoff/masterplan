import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/data/data_operator.dart';
import '../../../../widgets/element_bar.dart';
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Оператор'),
          // actions: const[ Center(child: Text('userInfo.number / userInfo.fio / userInfo.position / userInfo.regionNumber'))],
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElementBar(list: DataOperator.listWork),
            ],
          )
        ),
      ),
    )
      ),
    );
  }
}

class PageDetail extends StatelessWidget {
  const PageDetail({super.key, required this.detail, required this.operations});
  final String detail;
  final String operations;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
              LineTextSpawn(title: 'Деталь', text: detail),
              const SizedBox(height: 8),
              LineTextSpawn(title: 'Операция', text: operations),
              const SizedBox(height: 50),
              const TimerWidget(),
              // const SizedBox(height: 8),
              // ElevatedButton(onPressed: (){}, child: const Text('Начать работу')),
              const SizedBox(height: 100),
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
    );
  }
}