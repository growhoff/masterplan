import 'package:master_plan/domain/model/distribution_stage.dart';

class DistributionStageModel {
  DistributionStageModel({
    this.stagesList,
    required this.batchId,
    required this.stageArchiveId,
    required this.quantity,
    required this.batchName,
    required this.batchNumber,
    required this.stageName,
    required this.stageNumber,
    this.unitId,
  });

  final int quantity;
  final int batchId;
  final int stageArchiveId;
  final String stageNumber;
  final String stageName;
  final String batchName;
  final String batchNumber;
  final int? unitId;

  List<DistributionStage>? stagesList = [];
}
