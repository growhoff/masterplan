
class ChiefDistributionStageModel {
  ChiefDistributionStageModel(
      {required this.stageNumber,
      required this.planName,
      required this.planNumber,
      required this.stageName,
        required this.batchId,
        required this.stageId,
        required this.unitId,
        required this.technologyNumber,
      required this.priority});

  final String stageNumber;
  final String stageName;
  final String planNumber;
  final String planName;
  final String technologyNumber;
  final int priority;
  final int batchId;
  final int stageId;
  final int unitId;
  int receivedQuantity = 0;
  int waitingQuantity = 0;
}
