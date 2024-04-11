import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/domain/model/oper_operations.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';

import 'package:master_plan/presentation/pages/master/data/data_master.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/rowExpand.dart';
import '../../../../widgets/element_bar.dart';
import 'widgets/reorder_widget.dart';
import 'widgets/row_list_four.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class QueuePageMaster extends StatelessWidget {
  const QueuePageMaster({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ElementBar(list: DataMaster.listElementBarQueue),
            ],
          )
        ),
      ),
    );
  }
}

class ContetnQueue extends StatelessWidget {
  const ContetnQueue(this.title, {super.key});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
            BlocBuilder<CubitMain, StateMain>(
              builder: (context, state) {
                int time = 0;
                for (var num in state.listOperOperations!) {
                  time += int.parse(num.time);
                }
                return Row(
                  children: [
                    Text('Время работы станка $title: '),
                     Text('$time')
                  ],
                );
              }
            ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/addOperationPage'), 
                  child: const Text('Добавить операцию'),
                ),
              ),

              const SizedBox(height: 8),
              const RowExpand(text1: 'Деталь', text2: 'Операция', text3: 'Время обработки'),
              const SizedBox(height: 8),
              BlocBuilder<CubitMain, StateMain>( 
                builder: (context, state) {
                List<OperOperations> list = [];
                for (var element in state.listOperOperations!) {
                  if (element.status == 'ready') list.add(element);
                } 
                  return ListViewOperationsReady(list);
                }
              ),
              const SizedBox(height: 8),
              //лист с удалением элементов и изменением порядка
              BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                List<OperOperations> list = [];
                for (var element in state.listOperOperations!) {
                  if (element.status != 'ready') list.add(element);
                } 
                return ReorderWidget(list, header: const RowListFour(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки'));
              }
              )
      ],
    );
  }
}

class ListViewOperationsReady extends StatelessWidget {
  const ListViewOperationsReady(this.list, {super.key,});
  final List<OperOperations> list;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
    shrinkWrap: true,
    itemCount: list.length,
    itemBuilder: (context, index) => Card(
      color: Colors.amber,
      child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: RowExpand(text1: list[index].planNumber, text2: list[index].operationName, text3: list[index].time),
    ),),);
  }
}