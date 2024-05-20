import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';

import '../../../../data/repositories/supabase/dto/user_dto.dart';
import '../../../../domain/model/machine.dart';
import '../../../../domain/model/status.dart';

class StatisticsBatchModel {
  StatisticsBatchModel(
      {required this.chiefBatchId, required this.name, required this.number, this.stagesList});

  final String name;
  final String number;
  final int chiefBatchId;
  List<StatisticsStageModel2>? stagesList = [];
}

class StatisticsStageModel2 {
  StatisticsStageModel2({required this.stage, this.operationsList = const []});

  final StageDTO stage;
  int detailsQuantity = 0;
  int readyDetailsQuantity = 0;
  int readyDetailsPercent = 0;
  int defectDetailsQuantity = 0;

  int operationsQuantity = 0;
  int readyOperationsQuantity = 0;
  int readyOperationsPercent = 0;

  List<StatisticsOperationModel2>? operationsList;
}


class StatisticsOperationModel2 {

  final OperationDTO operation;
  int? operatorOperationsId;

  late final int? timePlan;
  late final int? timeFact;
  late final Status? status;
  late final MachineDTO? machine;
  late final int? timeStart;
  late final int? timeStop;
  late final int? timeWorking;
  late final UserDTO? user;

  StatisticsOperationModel2({
    required this.operation,
    this.status,
    this.timeFact,
    this.timePlan,
    this.machine,
    this.timeStart,
    this.timeStop,
    this.timeWorking,
    this.user,
    this.operatorOperationsId,
  });
}
