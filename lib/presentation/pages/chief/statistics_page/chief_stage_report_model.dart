class ChiefStageForReportModel {
  final int batchId;
  final String stageNumber;
  final String batchNumber;
  final String batchName;
  final String batchCode;

  int detailsQuantity = 0;

  int readyDetailsQuantity = 0;
  int readyDetailsPercent = 0;
  int defectDetailsQuantity = 0;

  int readyOperationsQuantity = 0;
  int operationsQuantity = 0;
  int readyOperationsPercent = 0;

  int defectOperationsQuantity = 0;
  int modificationOperationsQuantity = 0;
  int onDistributionOperationsQuantity = 0;
  int distributedOperationsQuantity = 0;

  List<ChiefOperationModel> operationsList = [];

  ChiefStageForReportModel(
      {required this.batchId,
      required this.batchNumber,
      required this.batchName,
      required this.batchCode,
      required this.stageNumber});
}

class ChiefOperationModel {
  ChiefOperationModel(
      {required this.name,
      required this.number,
      required this.operationId,
      required this.code});

  final int operationId;
  final String name;
  final String number;
  final String code;

  String areaNumber = '';

  int readyQuantity = 0;
  int readyPercent = 0;
  int onDistribution = 0;
  int distributed = 0;
  int defectQuantity = 0;
  int modificationQuantity = 0;
  int mustBeDone = 0;
}
