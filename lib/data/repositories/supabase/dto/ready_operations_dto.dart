import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ReadyOperationsDTO extends Dto{
  final int id;
  final int regionId;
  final int companyId;
  final int timePlan;
  final int timeFact;
  final int timeStart;
  final int timeStop;
  final int statusId;
  final int stageOperationId;
  final int detaildId;
  final int equipmentId;
  final int userId;
  final bool isUploaded;
  ReadyOperationsDTO({
    required this.id,
    required this.regionId,
    required this.companyId,
    required this.timePlan,
    required this.timeFact,
    required this.timeStart,
    required this.timeStop,
    required this.statusId,
    required this.stageOperationId,
    required this.detaildId,
    required this.equipmentId,
    required this.userId,
    required this.isUploaded,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'region_id': regionId,
      'company_id': companyId,
      'time_plan': timePlan,
      'time_fact': timeFact,
      'time_start': timeStart,
      'time_stop': timeStop,
      'status_id': statusId,
      'stage_operation_id': stageOperationId,
      'detaild_id': detaildId,
      'equipment_id': equipmentId,
      'user_id': userId,
      'is_uploaded': isUploaded,
    };
  }

  factory ReadyOperationsDTO.fromMap(Map<String, dynamic> map) {
    return ReadyOperationsDTO(
      id: map['id'] as int,
      regionId: map['region_id'] as int,
      companyId: map['company_id'] as int,
      timePlan: map['time_plan'] as int,
      timeFact: map['time_fact'] as int,
      timeStart: map['time_start'] as int,
      timeStop: map['time_stop'] as int,
      statusId: map['status_id'] as int,
      stageOperationId: map['stage_operation_id'] as int,
      detaildId: map['detaild_id'] as int,
      equipmentId: map['equipment_id'] as int,
      userId: map['user_id'] as int,
      isUploaded: map['is_uploaded'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadyOperationsDTO.fromJson(String source) => ReadyOperationsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
