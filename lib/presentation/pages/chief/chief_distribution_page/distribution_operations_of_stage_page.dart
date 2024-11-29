import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/chief_distirbution_cubit/chief_distribution_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/models/chief_distribution_stage_model.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/widgets/chief_distribution_list_item.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/widgets/distribution_operations_list_item.dart';

import '../../dispatcher/orders_page/widgets/priority_circle.dart';

class DistributionOperationsOfStagePage extends StatelessWidget {
  const DistributionOperationsOfStagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = ModalRoute
        .of(context)
        ?.settings
        .arguments
    as ChiefDistributionStageModel;
    return BlocProvider(
      create: (context) => ChiefDistributionCubit(),
      child: DistributionOperationsOfStagePageView(
        chiefDistributionStageModel: stage,
      ),
    );
  }
}

class DistributionOperationsOfStagePageView extends StatefulWidget {
  const DistributionOperationsOfStagePageView(
      {required this.chiefDistributionStageModel, super.key});

  final ChiefDistributionStageModel chiefDistributionStageModel;

  @override
  State<DistributionOperationsOfStagePageView> createState() =>
      _DistributionOperationsOfStagePageViewState();
}

class _DistributionOperationsOfStagePageViewState
    extends State<DistributionOperationsOfStagePageView> {
  @override
  void initState() {
    context.read<ChiefDistributionCubit>().initOperationsOfStagePage(
        batchId: widget.chiefDistributionStageModel.batchId,
        stageId: widget.chiefDistributionStageModel.stageId,
        unitId: widget.chiefDistributionStageModel.unitId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Операции этапа'),
      ),
      body: BlocBuilder<ChiefDistributionCubit, ChiefDistributionState>(
        builder: (context, state) {
          if (state is OperationsOfStagePageSuccess) {
            return Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Card(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                    flex: 4,
                                    child: Column(children: [
                                      Text(
                                          '${widget.chiefDistributionStageModel
                                              .stageNumber}, ${widget
                                              .chiefDistributionStageModel
                                              .stageName}',
                                          textAlign: TextAlign.start),
                                      Text(
                                          '${widget.chiefDistributionStageModel
                                              .planNumber}, ${widget
                                              .chiefDistributionStageModel
                                              .planName}',
                                          textAlign: TextAlign.start)
                                    ])),
                                Expanded(
                                    flex: 2,
                                    child: Text(
                                      '${widget.chiefDistributionStageModel
                                          .receivedQuantity} / ${widget
                                          .chiefDistributionStageModel
                                          .waitingQuantity}',
                                      textAlign: TextAlign.center,
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: PriorityCircle(
                                      widget.chiefDistributionStageModel
                                          .priority,
                                      size: 24,
                                    ))
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Divider(
                              height: 1,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'ТП: ${widget.chiefDistributionStageModel
                                    .technologyNumber}',
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                      child: ListView.separated(
                          itemBuilder: (context, index) =>
                              DistributionOperationsListItem(
                                index: index,
                                cubit: context.read<ChiefDistributionCubit>(),
                                operation: state.operationsList[index],
                                availableOperationsQuantity: widget
                                    .chiefDistributionStageModel
                                    .receivedQuantity,
                                areasList: state.areasList,
                              ),
                          separatorBuilder: (context, index) =>
                          const SizedBox(
                            height: 5,
                          ),
                          itemCount: state.operationsList.length)),
                  ElevatedButton(onPressed: () async{



                    await context.read<ChiefDistributionCubit>().distributeAll(
                        unitId: widget.chiefDistributionStageModel.unitId);


                    context.read<ChiefDistributionCubit>().initOperationsOfStagePage(
                        batchId: widget.chiefDistributionStageModel.batchId,
                        stageId: widget.chiefDistributionStageModel.stageId,
                        unitId: widget.chiefDistributionStageModel.unitId);
                  }, child: Text('Передать все'))
                ],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
