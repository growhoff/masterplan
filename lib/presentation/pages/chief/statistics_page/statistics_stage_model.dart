import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';

import '../../../../data/repositories/supabase/dto/batch_dto.dart';
import '../../../../data/repositories/supabase/dto/operation_dto.dart';

import '../../../../data/repositories/supabase/dto/user_dto.dart';
import '../../../../domain/model/area.dart';
import '../../../../domain/model/machine.dart';

import '../../../../domain/model/status.dart';

class StatisticsStageModel {
  StatisticsStageModel({required this.stage, required this.operationsList});

  final StageDTO stage;
  int? readyDetailsQuantity = 0;
  int? readyDetailsPercent = 0;
  int? defectDetailsQuantity = 0;
  num operationsQuantity = 0;
  int? readyOperationsQuantity = 0;
  int? readyOperationsPercent = 0;
  List<StatisticOperationModel> operationsList;
}

class StatisticOperationModel {
  final int id;
  final int stageId;
  final StageDTO stage;
  final int operationId;
  final OperationDTO operation;
  final int batchId;
  final BatchDTO batch;
  final int quantity;
  Area? area;

  List<ReadyOperationModel> readyOperationsList;

  num? readyPercent;

  //ключ - айди статуса, значение - кол-во
  Map<int, int> statusMap = {
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
    7: 0,
    8: 0,
    9: 0
  };

  StatisticOperationModel(
      {required this.id,
      required this.operationId,
      required this.stageId,
      required this.stage,
      required this.operation,
      required this.batchId,
      required this.batch,
      required this.quantity,
      required this.readyOperationsList,
        this.area
      });
}

class ReadyOperationModel {
  final int? timePlan;
  final int? timeFact;
  final Status? status;
  final Machine? machine;
  final int? timeStart;
  final int? timeStop;
  final int? timeWorking;
  final UserDTO? user;

  ReadyOperationModel(
      {this.status,
      this.timeFact,
      this.timePlan,
      this.machine,
      this.timeStart,
      this.timeStop,
      this.timeWorking,
        this.user,
      });
}
