class ChiefOperation {
  ChiefOperation(
      {required this.id,
      required this.stageId,
      required this.chiefBatchId,
      required this.operationId,
      required this.distributionStageId,
      required this.isDistributed});

  final int id;
  final int chiefBatchId;
  final int stageId;
  final int operationId;
  final bool isDistributed;
  final int distributionStageId;
}
