// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto2/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user2_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class OperatorOperationsDTO2 extends Dto {
  final int id;
  final int timeplan;
  final int timefact;
  final int timestart;
  final int timestop;
  final int timeworking;
  final StatusDTO2 status;
  final int stageoperationid;
  final int stagemasteroperationid;
  final BatchDTO2 batch;
  final User2DTO2 user;
  final bool isuploaded;
  final int order;
  final MachineDTO2 machine;
  OperatorOperationsDTO2({
    required this.id,
    required this.timeplan,
    required this.timefact,
    required this.timestart,
    required this.timestop,
    required this.timeworking,
    required this.status,
    required this.stageoperationid,
    required this.stagemasteroperationid,
    required this.batch,
    required this.user,
    required this.isuploaded,
    required this.order,
    required this.machine,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'time_plan': timeplan,
      'time_fact': timefact,
      'time_start': timestart,
      'time_stop': timestop,
      'time_working': timeworking,
      'status_id': status.toMap(),
      'stage_operation_id': stageoperationid,
      'stage_master_operation_id': stagemasteroperationid,
      'batch_id': batch.toMap(),
      'user_id': user.toMap(),
      'is_uploaded': isuploaded,
      'order': order,
      'machine_id': machine.toMap(),
    };
  }

  factory OperatorOperationsDTO2.fromMap(Map<String, dynamic> map) {
    return OperatorOperationsDTO2(
      id: map['id'] as int,
      timeplan: map['time_plan'] as int,
      timefact: map['time_fact'] as int,
      timestart: map['time_start'] as int,
      timestop: map['time_stop'] as int,
      timeworking: map['time_working'] as int,
      status: StatusDTO2.fromMap(map['z_status'] as Map<String,dynamic>),
      stageoperationid: map['stage_operation_id'] as int,
      stagemasteroperationid: map['stage_master_operation_id'] as int,
      batch: BatchDTO2.fromMap(map['z_batch'] as Map<String,dynamic>),
      user: User2DTO2.fromMap(map['z_user'] as Map<String,dynamic>),
      isuploaded: map['is_uploaded'] as bool,
      order: map['order'] as int,
      machine: MachineDTO2.fromMap(map['z_machine'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OperatorOperationsDTO2.fromJson(String source) => OperatorOperationsDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
  }
