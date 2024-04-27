class DistributionOperationModel {
  DistributionOperationModel({
    required this.chiefOperationId,
    required this.batchId,
    required this.operationId,
    required this.quantity,
    required this.stageId,
    required this.areaId,
    required this.oldQuantity
  });

  final int oldQuantity;
  final int chiefOperationId;
  final int statusId = 2;
  final int batchId;
  final int stageId;
  final int operationId;
  final int areaId;
  final int quantity;
}
