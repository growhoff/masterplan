// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class OperatorOperationsDTO extends Dto {
  final int id;
  final int? timeplan;
  final bool? pause;
  final int? timefact;
  final int statusId;
  final StatusDTO status;
  final int batchId;
  final BatchDTO batch;
  final int stageId;
  final StageDTO? stage;
  final int operationId;
  final OperationDTO operation;
  final int areaId;
  final AreaDTO? area;
  final int? chiefOperationId;
  final int? chiefBatchId;
  final ChiefOperationDto? chiefOperation;

  final int? machineId;
  final MachineDTO? machine;
  final int? order;

  final int? timestart;
  final int? timestop;
  final int? timeworking;
  final int? userId;
  final UserDTO? user;

  OperatorOperationsDTO({
    required this.id,
    this.timeplan,
    this.pause,
    this.timefact,
    required this.statusId,
    required this.status,
    required this.batchId,
    required this.batch,
    required this.stageId,
    this.stage,
    required this.operationId,
    required this.operation,
    required this.areaId,
    this.area,
    this.machineId,
    this.machine,
    this.order,
    this.timestart,
    this.timestop,
    this.timeworking,
    this.userId,
    this.user,
    this.chiefOperationId,
    this.chiefBatchId,
    this.chiefOperation,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'time_plan': timeplan,
      'time_fact': timefact,
      'status_id': statusId,
      'status': status.toMap(),
      'batch_id': batchId,
      'batch': batch.toMap(),
      'stage_id': stageId,
      'stage': stage?.toMap(),
      'operation_id': operationId,
      'operation': operation.toMap(),
      'area_id': areaId,
      'area': area?.toMap(),
      'machine_id': machineId,
      'machine': machine?.toMap(),
      'order': order,
      'time_start': timestart,
      'time_stop': timestop,
      'time_working': timeworking,
      'user_id': userId,
      'user': user?.toMap(),
    };
  }

  factory OperatorOperationsDTO.fromMap(Map<String, dynamic> map) {
    return OperatorOperationsDTO(
        id: map['id'] as int,
        timeplan: map['time_plan'] != null ? map['time_plan'] as int : null,
        pause: map['pause'] != null ? map['pause'] as bool : null,
        timefact: map['time_fact'] != null ? map['time_fact'] as int : null,
        statusId: map['status_id'] as int,
        status: StatusDTO.fromMap(map['z_status'] as Map<String, dynamic>),
        batchId: map['batch_id'] as int,
        batch: BatchDTO.fromMap(map['z_batch'] as Map<String, dynamic>),
        stageId: map['stage_id'] as int,
        stage: map['z_stage'] != null ? StageDTO.fromMap(map['z_stage'] as Map<String, dynamic>) : null,
        operationId: map['operation_id'] as int,
        operation: OperationDTO.fromMap(map['z_operation'] as Map<String, dynamic>),
        areaId: map['area_id'] as int,
        area: map['z_area'] != null ? AreaDTO.fromMap(map['z_area'] as Map<String, dynamic>) : null,
        machineId: map['machineId'] != null ? map['machine_id'] as int : null,
        machine: map['z_machine'] != null ? MachineDTO.fromMap(map['z_machine'] as Map<String, dynamic>) : null,
        order: map['order'] != null ? map['order'] as int : null,
        timestart: map['time_start'] != null ? map['time_start'] as int : null,
        timestop: map['time_stop'] != null ? map['time_stop'] as int : null,
        timeworking: map['time_working'] != null ? map['time_working'] as int : null,
        userId: map['user_id'] != null ? map['user_id'] as int : null,
        user: map['z_user'] != null ? UserDTO.fromMap(map['z_user'] as Map<String, dynamic>) : null,
        chiefBatchId: map['chief_batch_id'] != null ? map['chief_batch_id'] as int : null,
        chiefOperationId: map['chief_operation_id'] != null ? map['chief_operation_id'] as int : null,
        chiefOperation: map['z_chief_operation'] != null ? ChiefOperationDto.fromMap(map['z_chief_operation']) : null);
  }

  String toJson() => json.encode(toMap());

  factory OperatorOperationsDTO.fromJson(String source) =>
      OperatorOperationsDTO.fromMap(
          json.decode(source) as Map<String, dynamic>);
}
