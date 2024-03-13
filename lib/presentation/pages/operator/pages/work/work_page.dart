import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/operator/model/element_bar_data.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/bloc/cubit.dart';
// import 'package:master_plan/presentation/pages/operator/pages/work/bloc/state.dart';
import 'package:master_plan/presentation/pages/operator/widgets/element_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/app/bloc/cubit.dart';
import 'package:master_plan/presentation/app/bloc/state.dart';

import 'widgets/content_details.dart';

class WorkPage extends StatelessWidget {
  const WorkPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CubitWork>(
      create: (context) => CubitWork(),
      child: const ContentWork(),
    ); 
  }
}

class ContentWork extends StatelessWidget {
  const ContentWork({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<CubitMain, StateMain>(builder: (context, state) => Column(
            children: [
              const Text('Оператор'),
              Text('${state.user!.id} / ${state.user!.fio} / ${state.user!.position} / ${state.user!.region}', style: const TextStyle(fontSize: 12)),
            ])),
        ),
        body: SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BlocBuilder<CubitMain, StateMain>(builder: (context, state) {
                List<ElementBarDataOperator> list = [];
                for (var e in state.listoperatorOperations!) {
                  list.add(ElementBarDataOperator(header: e.equipment, content: ContentDetail(detail: e.details, operations: '${e.stageOperationId}', time: e.timeStart,)));
                }
                return ElementBarOperator(list: list);
              },)
            ],
          )
        ),
      ),
    )
      ),
    );
  }
}
