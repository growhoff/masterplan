class AnalyticsOperationModel {
  AnalyticsOperationModel(
      {required this.operationId,
      required this.code,
      required this.detailNumber,
      required this.operationNumber,
      required this.name,
      required this.timePlan,
      required this.timeFact,
      required this.machineName,
        required this.machineInventoryNumber,
      required this.fio,
      required this.date,
      required this.change,
      required this.areaNumber});

  final int operationId;
  final String code;
  final String detailNumber;
  final String operationNumber;
  final String name;
  final String timePlan;
  final String timeFact;
  final String machineName;
  final int machineInventoryNumber;
  final String fio;
  final String date;
  final int change;
  final String areaNumber;

  int defectQuantity = 0;
  int modificationQuantity = 0;
  int quantity = 0;
}
