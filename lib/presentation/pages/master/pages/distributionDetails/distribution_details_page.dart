import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';
import 'widgets/details_distrib_item.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:master_plan/presentation/app/bloc/cubit.dart';
// import 'package:master_plan/presentation/app/bloc/state.dart';

class DetailDistribPage extends StatelessWidget {
  const DetailDistribPage({super.key});
  @override
  Widget build(BuildContext context) {
    return  SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocBuilder<CubitMain, StateMain>(
                builder: (context, state) => ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.operatorOperationsList!.length,
                  itemBuilder: (context, index) => ListContetnDetails(state.operatorOperationsList![index])),//state.listStageMasterOperations![index]
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.maxFinite,
                child: ElevatedButton(onPressed: (){}, child: const Text('Отправить в работу')))
            ],
          )
        ),
      ),
    );
  }
}