import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/transfer.dart';
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
        operationId: dto.operationId,
        machine: dto.machine!
    );
  }

  static Machine converterToMachine(MachineDTO dto) {
    return Machine(
      id: dto.id,
      inventoryNumber: dto.inventoryNumber,
      isActivated: dto.isActivated,
      name: dto.name,
      areaId: dto.areaId,
      model: dto.model,
      prefix: dto.prefix,
      shiftSchedule: dto.shiftSchedule,
      viewMachine: dto.viewMachine,
      controlMachine: dto.controlMachine,
      typeMachine: dto.typeMachine,
      typeMachineId: dto.typeMachineId,
      viewMachineId: dto.viewId,
      shiftScheduleId: dto.shiftScheduleId,
      controlMachineId: dto.controlId,
    );
  }

  static Transfer convertToTransfer(TransferDTO dto){
    return Transfer(id: dto.id, number: dto.number, name: dto.name, code: dto.code, timesh: dto.timesh, operationId: dto.operationId);
  }

  static Order convertToOrder(OrderDTO dto){
    return Order(id: dto.id, number: dto.number, priority: dto.priority, statusId: dto.statusId);
  }

  static OperatorOperations convertToOperatorOperations(OperatorOperationsDTO dto, {List<Transfer>? listTransfer}) {
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
          order: dto.batch.order != null ? convertToOrder(dto.batch.order!) : null,
          isready: dto.batch.isready),
      order: dto.order,
      machine: dto.machine == null ? null : converterToMachine(dto.machine!),
      chiefBatchId: dto.chiefBatchId,
      chiefOperationId: dto.chiefOperationId,
      optimalPart: dto.optimalPart,
      modific: dto.modific,
      listTransfer: listTransfer,
      pause: dto.pause,
    );
  }
}
