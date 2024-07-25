import 'dart:core';

import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';

class StagesInUnitModel {
  StagesInUnitModel(
      {required this.batchId,
        required this.stageId,
        required this.stageNumber,
      required this.batchNumber,
      required this.batchName,
      required this.code,
      required this.technologyNumber,
      required this.stageStatusName});

  final int batchId;
  final int stageId;
  final String stageNumber;
  final String batchNumber;
  final String batchName;
  final String code;
  final String technologyNumber;
  final String stageStatusName;

  int totalDetailsQuantity = 0;
  int inUnitDetailsQuantity = 0;
  int inWorkDetailsQuantity = 0;

  int uploadedDetailsQuantity = 0;
  int expectedDetailsQuantity = 0;
  int availableDetailsQuantity = 0;

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
  int onCheckOperationQuantity = 0;
  int onMachinesOperationsQuantity = 0;

  int semisQuantity = 0;
  int missingSemisQuantity = 0;

  List<DistributionStage> stagesList = [];

  List<OperationInStageModel> operationsList = [];


}

class OperationInStageModel{
  OperationInStageModel(
      {required this.stageId,
        required this.name,
        required this.number,
        required this.operationId,
        required this.code});

  final int stageId;
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
  int onMachinesQuantity = 0;
  int onCheckQuantity = 0;
}

