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
                const SizedBox(height: 20),
                const Time(),
                const SizedBox(height: 30),
                const Divider(),
                const SizedBox(height: 16),
                SizedBox(width: double.maxFinite, child: ElevatedButtonCastom(text: 'Деталь готова', color: Colors.green, onPressed: (){},)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(flex: 5, child: SizedBox(width: double.maxFinite, child: ElevatedButtonCastom(text: 'Уборка', color: Colors.blueGrey, onPressed: (){},))),
                    const Spacer(),
                    Expanded(flex: 5, child: SizedBox(width: double.maxFinite, child: ElevatedButtonCastom(text: 'Переналадка', color: Colors.amber, onPressed: (){},))),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(width: double.maxFinite, child: ElevatedButtonCastom(text: 'Поломка', color: Colors.red, onPressed: (){},)),
        ],
      );}
    );
  }
}