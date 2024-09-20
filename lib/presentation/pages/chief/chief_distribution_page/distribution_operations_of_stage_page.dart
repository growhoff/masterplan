import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/chief_distirbution_cubit/chief_distribution_cubit.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/chief_distribution_stage_model.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/widgets/chief_distribution_list_item.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/widgets/distribution_operations_list_item.dart';

class DistributionOperationsOfStagePage extends StatelessWidget {
  const DistributionOperationsOfStagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final stage = ModalRoute.of(context)?.settings.arguments
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
            return Center(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    ChiefDistributionListItem(
                        widget.chiefDistributionStageModel),
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
                    ElevatedButton(
                        onPressed: () {}, child: Text('Передать все'))
                  ],
                ),
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
