import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:master_plan/domain/usecase/chief_unit_service.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/stages_in_unit_cubit/stages_in_unit_cubit.dart';
import 'package:master_plan/presentation/pages/chief/stages_in_unit_page/widgets/stages_in_unit_title_item.dart';
import 'package:master_plan/presentation/pages/dispatcher/queue_stages_page/queue_stages_cubit/queue_stages_cubit.dart';
import 'package:master_plan/presentation/pages/dispatcher/queue_stages_page/widgets/queue_stage_item.dart';

import '../../../../domain/model/unit.dart';

class QueueStagesPage extends StatelessWidget {
  const QueueStagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => QueueStagesCubit(),
      child: QueueStagesPageView(),
    );
  }
}

class QueueStagesPageView extends StatefulWidget {
  const QueueStagesPageView({super.key});

  @override
  State<QueueStagesPageView> createState() => _QueueStagesPageViewState();
}

class _QueueStagesPageViewState extends State<QueueStagesPageView> {
  @override
  void initState() {
    context.read<QueueStagesCubit>().initQueueStagesPage();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: BlocBuilder<QueueStagesCubit, QueueStagesState>(
        builder: (context, state) {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 10,
          ),
          DropdownButton<Unit>(
              value: context.read<QueueStagesCubit>().selectedUnit,
              items: state.unitsList
                  .map((Unit unit) => DropdownMenuItem(
                        value: unit,
                        child: Text('${unit.number} ${unit.name}'),
                      ))
                  .toList(),
              onChanged: (Unit? value) => setState(() {
                    context.read<QueueStagesCubit>().selectedUnit =
                        value ?? Unit.empty;

                    context.read<QueueStagesCubit>().fetchStages();
                  })),
          const SizedBox(
            height: 10,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Text(
                        '№ этапа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        '№ чертежа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 2,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Наименование',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Готово к выгрузке',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        '% выполнения этапа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                  Expanded(
                    child: Container(
                      child: Text(
                        'Состояние этапа',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          state.status == QueueStagesPageStatus.success
              ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => QueueStageItem(
                              state.stagesList[index],
                              setState: () => setState(() {
                                Navigator.pop(context);
                                context.read<QueueStagesCubit>().fetchStages();
                              }),
                            ),
                        separatorBuilder: (context, i) => SizedBox(height: 10),
                        itemCount: state.stagesList.length),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                )
        ],
      );
    }));
  }
}
