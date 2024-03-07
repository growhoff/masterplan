import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/data/data_master.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/widgets/rowExpand.dart';
import '../../../../widgets/element_bar.dart';
import 'widgets/reorder_widget.dart';
import 'widgets/row_list_four.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class QueuePage extends StatelessWidget {
  const QueuePage({super.key});
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
         Row(
                children: [
                  Text('Время работы станка $title: '),
                  const Text('[timeConverter]')
                ],
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
              ListView.builder(
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) => const Card(
                  color: Colors.amber,
                  child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: RowExpand(text1: '[detailNumber]', text2: '[operationName]', text3: '[timeFact]'),
                ),),),
              const SizedBox(height: 8),
              //лист с удалением элементов и изменением порядка
              const ReorderWidget(['1','2','3'], header: RowListFour(text1: 'Деталь', text2: 'Номер', text3: 'Время обработки'))
      ],
    );
  }
}