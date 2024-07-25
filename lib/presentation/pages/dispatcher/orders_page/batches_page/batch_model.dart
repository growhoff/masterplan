import '../../../../../domain/model/batch.dart';

class BatchModel {
  final Batch batch;
  int inWorkQuantity = 0;
  int readyQuantity = 0;
  int defectQuantity = 0;
  int readyPercent = 0;


  BatchModel({required this.batch});
}

class StageInBatchModel {
  StageInBatchModel({required this.stageNumber, required this.stageName});

  final String stageNumber;
  final String stageName;
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
