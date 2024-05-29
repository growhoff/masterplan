// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:intl/intl.dart';

class MonitoringMachineDTO extends Dto {
  final int id;
  final int timeStart;
  final int timeStop;
  final int statusMachineId;
  final StatusMachineDTO? statusMachine;
  final int userId;
  final UserDTO? user;
  final int machineId;
  final MachineDTO? machine;
  final int batchId;
  final BatchDTO? batch;
  final String comment;
  final DateTime date;
  final int changeId;
  final int operationId;
  MonitoringMachineDTO({
    required this.id,
    required this.timeStart,
    required this.timeStop,
    required this.statusMachineId,
    this.statusMachine,
    required this.userId,
    this.user,
    required this.machineId,
    this.machine,
    required this.batchId,
    this.batch,
    required this.comment,
    required this.date,
    required this.changeId,
    required this.operationId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'time_start': timeStart,
      'time_stop': timeStop,
      'status_machine_id': statusMachineId,
      'user_id': userId,
      'machine_id': machineId,
      'batch_id': batchId,
      'comment': comment,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'change_id': changeId,
      'operation_id':operationId,
    };
  }

  factory MonitoringMachineDTO.fromMap(Map<String, dynamic> map) {
    final listTime = (map['date'] as String).split('-');
    return MonitoringMachineDTO(
      id: map['id'] as int,
      timeStart: map['time_start'] as int,
      timeStop: map['time_stop'] as int,
      statusMachineId: map['status_machine_id'] as int,
      statusMachine: map['z_status_machine'] != null ? StatusMachineDTO.fromMap(map['z_status_machine'] as Map<String,dynamic>) : null,
      userId: map['user_id'] as int,
      user: map['z_user'] != null ? UserDTO.fromMap(map['z_user'] as Map<String,dynamic>) : null,
      machineId: map['machine_id'] as int,
      machine: map['z_machine'] != null ? MachineDTO.fromMap(map['z_machine'] as Map<String,dynamic>) : null,
      batchId: map['batch_id'] as int,
      batch: map['z_batch'] != null ? BatchDTO.fromMap(map['z_batch'] as Map<String,dynamic>) : null,
      comment: map['comment'] as String,
      date: DateTime.tryParse(map['date'] as String) ?? DateTime(int.parse(listTime[0]), int.parse(listTime[1]), int.parse(listTime[2])),
      changeId: map['change_id'] as int,
      operationId: map['operation_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory MonitoringMachineDTO.fromJson(String source) => MonitoringMachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
