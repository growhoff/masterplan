import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/usecase/time_converter.dart';

class ConvertDtoModel {
  ConvertDtoModel();

  static TimeConverter timeConverter = TimeConverter();

  static MonitoringMachine converterToMonitorMachine(MonitoringMachineDTO dto) {
    return MonitoringMachine(
        id: dto.id,
        date: dto.date,
        timeStart: dto.timeStart,
        timeStop: dto.timeStop,
        timeWorking: (dto.timeStop < dto.timeStart)
            ? 0
            : timeConverter.getTimeWorking(dto.timeStart, dto.timeStop),
        statusMachine: dto.statusMachine!,
        comment: dto.comment,
        changeId: dto.changeId,
        batch: dto.batch,
        user: dto.user,
        operationId: dto.operationId);
  }

  static OperatorOperations convertToOperatorOperations(
      OperatorOperationsDTO dto) {
    return OperatorOperations(
      id: dto.id,
      area: dto.area!,
      operation: dto.operation,
      stage: dto.stage!,
      timeplan: dto.timeplan ?? 0,
      timeFirstStart: dto.timeFirstStart ?? 0,
      timestart: dto.timestart,
      timestop: dto.timestop,
      timeworking: dto.timeworking,
      status: Status(id: dto.status.id, name: dto.status.name),
      batch: Batch(
          id: dto.batch.id,
          numberRS: dto.batch.numberRS,
          name: dto.batch.name,
          count: dto.batch.count,
          code: dto.batch.code,
          orderId: dto.batch.orderId,
          technology: dto.batch.technology,
          number: dto.batch.number,
          // order: dto.batch.order,
          isready: dto.batch.isready),
      order: dto.order,
      machine: Machine(
          id: dto.machine!.id,
          inventoryNumber: dto.machine!.inventoryNumber,
          isActivated: dto.machine!.isActivated,
          name: dto.machine!.name,
          areaId: dto.areaId),
      chiefBatchId: dto.chiefBatchId,
      chiefOperationId: dto.chiefOperationId,
      optimalPart: dto.optimalPart,
      modific: dto.modific,
    );
  }
}
