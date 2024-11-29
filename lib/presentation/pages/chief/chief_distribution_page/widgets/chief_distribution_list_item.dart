import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_plan/presentation/pages/chief/chief_distribution_page/models/chief_distribution_stage_model.dart';
import 'package:master_plan/presentation/pages/dispatcher/orders_page/widgets/priority_circle.dart';

class ChiefDistributionListItem extends StatelessWidget {
  const ChiefDistributionListItem(this.chiefDistributionStageModel,
      {required this.setState, super.key});

  final ChiefDistributionStageModel chiefDistributionStageModel;
  final VoidCallback setState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/distributionOperationsOfStagePage',
                arguments: chiefDistributionStageModel)
            .then((_) => setState());
      },
      child: Card(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                flex: 4,
                child: Column(children: [
                  Text(
                      '${chiefDistributionStageModel.stageNumber}, ${chiefDistributionStageModel.stageName}',
                      textAlign: TextAlign.center),
                  Text(
                      '${chiefDistributionStageModel.planNumber}, ${chiefDistributionStageModel.planName}',
                      textAlign: TextAlign.center)
                ])),
            Expanded(
                flex: 2,
                child: Text(
                  '${chiefDistributionStageModel.receivedQuantity} / ${chiefDistributionStageModel.waitingQuantity}',
                  textAlign: TextAlign.center,
                )),
            Expanded(
                flex: 1,
                child: PriorityCircle(
                  chiefDistributionStageModel.priority,
                  size: 24,
                ))
          ],
        ),
      )),
    );
  }
}
