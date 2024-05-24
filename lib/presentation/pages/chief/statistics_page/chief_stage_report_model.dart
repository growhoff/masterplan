class ChiefStageForReportModel {

  final int batchId;
  final String stageNumber;
  final String batchNumber;
  final String batchName;
  final String batchCode;

  int detailsQuantity = 0;
  int detailsInWorkQuantity = 0;

  int readyDetailsQuantity = 0;
  int readyDetailsPercent = 0;
  int defectDetailsQuantity = 0;

  int readyOperationsQuantity = 0;
  int operationsQuantity = 0;
  int readyOperationsPercent = 0;

  ChiefStageForReportModel(
      {required this.batchId,
        required this.batchNumber,
      required this.batchName,
      required this.batchCode,
      required this.stageNumber});
}
