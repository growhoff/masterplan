class AnalyticsOperationModel {
  AnalyticsOperationModel(
      {
        required this.operationId,
        required this.code,
        required this.comment,
        required this.detailNumber,
        required this.detailName,
        required this.operationNumber,
        required this.operationName,
        required this.timePlan,
        required this.timeFact,
        required this.machineName,
        required this.machineInventoryNumber,
        required this.fio,
        required this.date,
        required this.change,
        required this.areaNumber});


  final String detailName;
  final int operationId;
  final String code;
  final String detailNumber;
  final String operationNumber;
  final String operationName;
  final String timePlan;
  final String timeFact;
  final String machineName;
  final int machineInventoryNumber;
  final String fio;
  final String date;
  final String comment;
  final int change;
  final String areaNumber;

  int defectQuantity = 0;
  int modificationQuantity = 0;
  int quantity = 0;
}



