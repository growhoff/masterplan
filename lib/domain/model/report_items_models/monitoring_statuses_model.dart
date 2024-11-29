class MonitoringStatusesModel {
  MonitoringStatusesModel({
    required this.optimalBatchId,
    required this.stageNumber,
    required this.batchNumber,
    required this.batchName,
    required this.operationName,
    required this.inventoryNumber,
    required this.dateStart,
    required this.timeStart,
    required this.dateEnd,
    required this.statusName,
    required this.unitNumber,
    required this.unitName,
    required this.areaNumber,
    required this.areaName,
    required this.machineName,
    required this.fio,
    required this.change,
    required this.timeEnd,
    required this.duration,
    required this.comment,
  });

  final String optimalBatchId;
  final String stageNumber;
  final String batchNumber;
  final String batchName;
  final String operationName;
  final String statusName;
  final String unitNumber;
  final String unitName;
  final String areaNumber;
  final String areaName;
  final String inventoryNumber;
  final String machineName;
  final String dateStart;
  final String timeStart;
  final String dateEnd;
  final String timeEnd;
  final String duration;
  final String fio;
  final int change;
  final String comment;
}
