import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/monitoring_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/monitoring_machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/domain/model/order.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/transfer.dart';
import 'package:master_plan/domain/model/user.dart';
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

  static Area converterToArea(AreaDTO dto) {
    return Area(id: dto.id, name: dto.name, number: dto.number, unitId: dto.unitId);
  }

  static Machine converterToMachine(MachineDTO dto) {
    return Machine(
      id: dto.id,
      inventoryNumber: dto.inventoryNumber,
      isActivated: dto.isActivated,
      name: dto.name,
      areaId: dto.areaId,
      area: dto.area != null ? converterToArea(dto.area!) : null,
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

  static Position convertToPosition(PositionDTO dto){
    return Position(id: dto.id, name: dto.name);
  }

  static Company convertToCompany(CompanyDTO dto){
    return Company(id: dto.id, name: dto.name, code: dto.code);
  }

  static Transfer convertToTransfer(TransferDTO dto){
    return Transfer(id: dto.id, number: dto.number, name: dto.name, code: dto.code, timesh: dto.timesh, operationId: dto.operationId);
  }

  static Order convertToOrder(OrderDTO dto){
    return Order(id: dto.id, number: dto.number, priority: dto.priority, statusId: dto.statusId);
  }

  static User convertToUser(StaffDTO dto){
    return User(id: dto.id, fio: dto.fio, positionId: dto.positionId, companyId: dto.companyId!, company: convertToCompany(dto.company!), unitId: null, areaId: null, photo: dto.photo, position: convertToPosition(dto.position));
  }

  static Batch convertToBatch(BatchDTO dto){
    return Batch(
        id: dto.id,
        numberRS: dto.numberRS,
        name: dto.name,
        count: dto.count,
        code: dto.code,
        orderId: dto.orderId,
        technology: dto.technology,
        number: dto.number,
        order: dto.order != null ? convertToOrder(dto.order!) : null,
        );
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
      user: dto.staff == null ? null : convertToUser(dto.staff!),
      status: Status(id: dto.status.id, name: dto.status.name),
      batch: convertToBatch(dto.batch),
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
