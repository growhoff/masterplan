import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'line_text_spawn.dart';
import 'timer/timer.dart';
import 'elevated_button_castom.dart';

class ContentDetail extends StatelessWidget {
  const ContentDetail({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CubitWork, StateWork>(builder: (context, state) {
      final data = state.pageData[state.activePage];
        String detail;
        String operations;
      if (data.operList.isEmpty){
        detail = 'none';
        operations = 'none';
      }
      else {
        detail = data.operList.first.batch.name;
        operations = data.operList.first.batch.stageList.first.operationList.first.name;
      } 
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                LineTextSpawn(title: 'Деталь', text: detail),
                const SizedBox(height: 8),
                LineTextSpawn(title: 'Операция', text: operations),
                const SizedBox(height: 50),
                const Time(),
                const SizedBox(height: 100),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButtonCastom(text: 'Переналадка', color: Colors.amber, onPressed: (){},),
                    ElevatedButtonCastom(text: 'Уборка', color: Colors.blueGrey, onPressed: (){},),
                  ],
                ),
                const SizedBox(height: 8),
                ElevatedButtonCastom(text: 'Деталь готова', color: Colors.green, onPressed: (){},),
                const SizedBox(height: 8),
                ElevatedButtonCastom(text: 'Поломка', color: Colors.red, onPressed: (){},)
        ],
      );}
    );
  }
}