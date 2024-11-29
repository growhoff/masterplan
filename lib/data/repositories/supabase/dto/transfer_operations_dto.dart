// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/transfer_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class TransferOperationsDTO extends Dto {
  final int id;
  final bool? pause;
  final int? timeFirstStart;
  final int? timestart;
  final int? timestop;
  final int? timeworking;
  final int? staffId;
  final StaffDTO? staff;
  final int batchId;
  final BatchDTO? batch;
  final int? machineId;
  final MachineDTO? machine;
  final int operationId;
  final OperationDTO? operation;
  final int? chiefOperationId;
  final ChiefOperationDto? chiefOperation;
  final int optPath;
  final int? transferId;
  final TransferDTO? transferDTO;
  final int order;
  final int? operatorOperationId;

  TransferOperationsDTO({
    required this.id,
    this.pause,
    this.timeFirstStart,
    this.timestart,
    this.timestop,
    this.timeworking,
    this.staffId,
    this.staff,
    required this.batchId,
    this.batch,
    this.machineId,
    this.machine,
    required this.operationId,
    this.operation,
    this.chiefOperationId,
    this.chiefOperation,
    required this.optPath,
    this.transferId,
    this.transferDTO,
    required this.order,
    this.operatorOperationId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'pause': pause,
      'time_first_start': timeFirstStart,
      'time_start': timestart,
      'time_stop': timestop,
      'time_working': timeworking,
      'staff_id': staffId,
      'batch_id': batchId,
      'machine_id': machineId,
      'operation_id': operationId,
      // 'chief_operation_id': chiefOperationId,
      'opt_path': optPath,
      'transfer_id': transferId,
      'order': order,
      'operator_operation_id': operatorOperationId,
    };
  }

  factory TransferOperationsDTO.fromMap(Map<String, dynamic> map) {
    return TransferOperationsDTO(
      id: map['id'] as int,
      pause: map['pause'] != null ? map['pause'] as bool : null,
      timeFirstStart: map['time_first_start'] != null
          ? map['time_first_start'] as int
          : null,
      timestart: map['time_start'] != null ? map['time_start'] as int : null,
      timestop: map['time_stop'] != null ? map['time_stop'] as int : null,
      timeworking:
          map['time_working'] != null ? map['time_working'] as int : null,
      staffId: map['staff_id'] != null ? map['staff_id'] as int : null,
      staff: map['z_staff'] != null
          ? StaffDTO.fromMap(map['z_staff'] as Map<String, dynamic>)
          : null,
      batchId: map['batch_id'] as int,
      batch: map['z_batch'] != null
          ? BatchDTO.fromMap(map['z_batch'] as Map<String, dynamic>)
          : null,
      machineId: map['machine_id'] != null ? map['machine_id'] as int : null,
      machine: map['z_machine'] != null
          ? MachineDTO.fromMap(map['z_machine'] as Map<String, dynamic>)
          : null,
      operationId: map['operation_id'] as int,
      operation: map['z_operation'] != null
          ? OperationDTO.fromMap(map['z_operation'] as Map<String, dynamic>)
          : null,
      chiefOperationId: map['chief_operation_id'] != null
          ? map['chief_operation_id'] as int
          : null,
      chiefOperation: map['z_chiefOperation'] != null
          ? ChiefOperationDto.fromMap(
              map['z_chiefOperation'] as Map<String, dynamic>)
          : null,
      optPath: map['opt_path'] as int,
      transferId: map['transfer_id'] != null ? map['transfer_id'] as int : null,
      transferDTO: map['z_transfer'] != null
          ? TransferDTO.fromMap(map['z_transfer'])
          : null,
      order: map['order'] as int,
      operatorOperationId: map['operator_operation_id'] != null
          ? map['operator_operation_id'] as int
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TransferOperationsDTO.fromJson(String source) =>
      TransferOperationsDTO.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
