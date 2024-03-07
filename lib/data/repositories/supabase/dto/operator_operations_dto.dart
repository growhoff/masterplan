import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class OperatorOperationsDTO extends Dto{
  final int id;
  final int order;
  final int regionId;
  final int companyId;
  final int time;
  final int timeStart;
  final int timeWorking;
  final int statusId;
  final int stageOperationId;
  final int stageMasterOperationId;
  final int equipmentId;
  final int detailsId;
  OperatorOperationsDTO({
    required this.id,
    required this.order,
    required this.regionId,
    required this.companyId,
    required this.time,
    required this.timeStart,
    required this.timeWorking,
    required this.statusId,
    required this.stageOperationId,
    required this.stageMasterOperationId,
    required this.equipmentId,
    required this.detailsId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'order': order,
      'region_id': regionId,
      'company_id': companyId,
      'time': time,
      'time_start': timeStart,
      'time_working': timeWorking,
      'status_id': statusId,
      'stage_operation_id': stageOperationId,
      'stage_master_operation_id': stageMasterOperationId,
      'equipment_id': equipmentId,
      'details_id': detailsId,
    };
  }

  factory OperatorOperationsDTO.fromMap(Map<String, dynamic> map) {
    return OperatorOperationsDTO(
      id: map['id'] as int,
      order: map['order'] as int,
      regionId: map['region_id'] as int,
      companyId: map['company_id'] as int,
      time: map['time'] as int,
      timeStart: map['time_start'] as int,
      timeWorking: map['time_working'] as int,
      statusId: map['status_id'] as int,
      stageOperationId: map['stage_operation_id'] as int,
      stageMasterOperationId: map['stage_master_operation_id'] as int,
      equipmentId: map['equipment_id'] as int,
      detailsId: map['details_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory OperatorOperationsDTO.fromJson(String source) => OperatorOperationsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
