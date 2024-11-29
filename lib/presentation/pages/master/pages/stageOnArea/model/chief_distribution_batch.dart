// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/presentation/pages/master/pages/stageOnArea/model/chief_distribution_stage.dart';

class ChiefDistributionBatch {
  final int batchId;
  final List<ChiefDistributionStage> stageList;
  ChiefDistributionBatch({
    required this.batchId,
    required this.stageList,
  });
}
