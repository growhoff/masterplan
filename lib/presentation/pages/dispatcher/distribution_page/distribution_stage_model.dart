import 'package:master_plan/domain/model/distribution_stage.dart';

import '../../../../data/repositories/supabase/dto/batch_dto.dart';
import '../../../../domain/model/batch.dart';

class DistributionStageModel {
  DistributionStageModel({
    this.stagesList,
    required this.batch,
    required this.batchId,
    required this.stageId,
    required this.quantity,

    required this.stageName,
    required this.stageNumber,
    this.unitId,
  });

  final int quantity;
  final int batchId;
  final BatchDTO batch;
  final int stageId;
  final String stageNumber;
  final String stageName;
  final int? unitId;

  List<DistributionStage>? stagesList = [];
}
