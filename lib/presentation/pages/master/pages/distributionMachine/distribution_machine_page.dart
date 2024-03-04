import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/master/pages/distributionMachine/widgets/data_list.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});
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