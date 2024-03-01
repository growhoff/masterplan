import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';
import 'package:master_plan/presentation/pages/master/widgets/bottom_app_bar.dart';
import 'package:master_plan/presentation/pages/master/widgets/change_list_operator.dart';
import 'package:master_plan/presentation/pages/master/widgets/tab_bar_view.dart';

import 'widgets/calendar.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

List<String> list = ['ФИО1', 'ФИО2', 'ФИО3'];

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ContentMaster();
  }
}

class ContentMaster extends StatelessWidget {
  const ContentMaster({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: DataMaster.tabs.length,
      child: GestureDetector(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Master Список смен'),
            actions: [
              Tooltip(
                message: 'Закрепить все',
                child: IconButton(onPressed: (){
                  // await actions.updateEquipmentCustomReset();
                  // await actions.updateEquipmentCustom();
                }, icon: const Icon(Icons.auto_fix_high),),
              ),
              Tooltip(
                message: 'Открепить все',
                child: IconButton(onPressed: (){
                  // await actions.updateEquipmentCustomReset();
                }, icon: const Icon(Icons.auto_fix_off),),
              )
            ],
          ),
          bottomNavigationBar: const BottomAppBarCastom(),
          body: const TabBarViewCustom()
        ),
      ),
    );
  }
}

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [  
                  
                  const Card(child: Calendar()),
                  const SizedBox(height: 8),
                  const Text('Распределение на станки'),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(onPressed: (){}, child: const Text('1 смена')),
                      ElevatedButton(onPressed: (){}, child: const Text('2 смена'))
                    ],
                  ),
                  const SizedBox(height: 8),
                  ChangeListOperator(list),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(onPressed: (){Navigator.pushNamed(context, '/choosingOperatorPage');}, child: const Text('Назначить')),
                  )
                ],
              ),
              ),
          ),
        );
  }
}
