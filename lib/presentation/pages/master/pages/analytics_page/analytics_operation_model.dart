import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import '../../../../../domain/model/batch.dart';

class AnalyticsOperationModel {
  AnalyticsOperationModel(
      {required this.batch,
      required this.stage,
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
      required this.dateEnd,
      required this.dateStart,
      required this.timeStart,
      required this.timeEnd,
      required this.change,
      required this.areaNumber,
      required this.unitNumber});

  final Batch batch;
  final StageDTO stage;
  final String detailName;
  final int operationId;
  final String code;
  final String detailNumber;
  final String operationNumber;
  final String operationName;
  final int timePlan;
  final int timeFact;
  final String machineName;
  final int machineInventoryNumber;
  final String fio;
  final String dateEnd;
  final String dateStart;
  final String timeStart;
  final String timeEnd;
  final String comment;
  final int change;
  final String areaNumber;
  final String unitNumber;

  List<TransferAnalyticsModel> transfersList = [];

  int defectQuantity = 0;
  int modificationQuantity = 0;
  int quantity = 0;
}

class TotalNumberReadyOperationModel {
  TotalNumberReadyOperationModel(
      {required this.stageNumber,
      required this.planNumber,
      required this.code,
      required this.unitNumber,
      required this.operationName,
      required this.areaNumber,
      required this.planName});

  final String stageNumber;
  final String unitNumber;
  final String areaNumber;
  final String planNumber;
  final String planName;
  final String operationName;
  final String code;
  int defectQuantity = 0;
  int modificationQuantity = 0;
  int totalQuantity = 0;
}

class TransferAnalyticsModel {
  TransferAnalyticsModel(
      {required this.id,
      required this.number,
      required this.name,
      required this.timePlan,
      required this.areaNumber,
      required this.fio,
      required this.timeStart,
      required this.timeEnd,
      required this.dateEnd,
      required this.dateStart,
      required this.machineInventoryNumber,
      required this.machineName,
      required this.timeFact,
      required this.change,
      required this.unitNumber,
      required this.code});

  final int id;
  final String number;
  final String name;
  final int timePlan;
  final int timeFact;
  final String dateStart;
  final String dateEnd;
  final String timeStart;
  final int machineInventoryNumber;
  final String fio;
  final String timeEnd;
  final String machineName;
  final int change;
  final String areaNumber;
  final String unitNumber;

  final String code;
}
