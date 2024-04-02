import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'package:master_plan/presentation/pages/master/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/rowExpand.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/rowExpandContent.dart';

import '../../../../widgets/element_bar.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class ReadyDetailsPage extends StatelessWidget {
  const ReadyDetailsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                List<ElementBarData> list = [];
                for (var element in state.listReadyOperations!) {
                  list.add(ElementBarData(header: element.equipment, content: ContetnReady(title: element.equipment, detailNumber: element.details, operationName: '${element.stageOperationId}', timeFact: element.timeFact, timeJob:  element.timeStop - element.timeStart)));
                }
                return ElementBar(list: list);
              }),
            ],
          )
        ),
      ),
    );
  }
}

class ContetnReady extends StatelessWidget {
  const ContetnReady({super.key, required this.title, required this.detailNumber, required this.operationName, required this.timeFact ,required this.timeJob});
  final String title;
  final String detailNumber;
  final String operationName;
  final int timeFact;
  final int timeJob;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Row(
                children: [
                  Text('Время работы станка - $title: '),
                  Text('$timeJob')
                ],
              ),
              const SizedBox(height: 8),
              const RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки'),
              const SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) => Card(child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RowExpandContent(text1: detailNumber, text2: operationName, text3: '$timeFact'),
                ),),),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () {}, 
                  child: const Text('Вызгрузить'),
                ),
              )
      ],
    );
  }
}