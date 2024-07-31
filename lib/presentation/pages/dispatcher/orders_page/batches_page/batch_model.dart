import '../../../../../domain/model/batch.dart';
import '../../../../../domain/model/operation.dart';

class BatchModel {
  final Batch batch;

  int inWorkQuantity = 0;
  int readyQuantity = 0;
  int defectQuantity = 0;
  int readyPercent = 0;

  BatchModel({required this.batch});
}

class StageInBatchModel {
  StageInBatchModel(
      {required this.stageId,
      required this.stageNumber,
      required this.stageName});

  final String stageNumber;
  final String stageName;
  final int stageId;

  List<int> distributionStagesIdsList = [];

  int inWorkQuantity = 0;
  int readyToUploadQuantity = 0;
  int allOnStageQuantity = 0;
  int waitFromPrevStagesQuantity = 0;
  int uploadedQuantity = 0;
  int readyQuantity = 0;
  int defectQuantity = 0;
  int readyPercent = 0;
  String status = '';
}

class OperationInStageModel {
  OperationInStageModel({required this.operation});

  final Operation operation;

  int totalOperationsQuantity = 0;

  String areaNumber = '';

  int readyQuantity = 0;
  int readyPercent = 0;
  int onDistribution = 0;
  int distributed = 0;
  int defectQuantity = 0;
  int modificationQuantity = 0;
  int onMachinesQuantity = 0;
  int onCheckQuantity = 0;
}
