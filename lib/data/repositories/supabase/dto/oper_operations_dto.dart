import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class OperatorsOperationsDTO extends Dto {
  final int id;
  final int region;
  final String company;
  final String status;
  final int onEquipmentQuantity;
  final String planNumber;
  final String operationName;
  final int operationNumber;
  final String time;
  final String equipmentName;
  final int workingTime;
  final String timeStart;
  final bool isUploaded;
  final int order;
  final int stageOperationId;
  final int stageMasterOperationId;

  // final String inventoryNumber;
  // final String stage;
  // final String code;
  OperatorsOperationsDTO({
    required this.id,
    required this.region,
    required this.company,
    required this.status,
    required this.onEquipmentQuantity,
    required this.planNumber,
    required this.operationName,
    required this.operationNumber,
    required this.time,
    required this.equipmentName,
    required this.workingTime,
    required this.timeStart,
    required this.isUploaded,
    required this.order,
    required this.stageOperationId,
    required this.stageMasterOperationId,
    // required this.inventoryNumber,
    // required this.stage,
    // required this.code,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'region': region,
      'company': company,
      'status': status,
      'on_equipment_quantity': onEquipmentQuantity,
      'plan_number': planNumber,
      'operation_name': operationName,
      'operation_number': operationNumber,
      'time': time,
      'equipment_name': equipmentName,
      'working_time': workingTime,
      'time_start': timeStart,
      'is_uploaded': isUploaded,
      'order': order,
      'stage_operation_id': stageOperationId,
      'stage_master_operation_id': stageMasterOperationId,
      // 'inventory_number': inventoryNumber,
      // 'stage': stage,
      // 'code': code,
    };
  }

  factory OperatorsOperationsDTO.fromMap(Map<String, dynamic> map) {
    return OperatorsOperationsDTO(
      id: map['id'] as int,
      region: map['region'] as int,
      company: map['company'] as String,
      status: map['status'] as String,
      onEquipmentQuantity: map['on_equipment_quantity'] as int,
      planNumber: map['plan_number'] as String,
      operationName: map['operation_name'] as String,
      operationNumber: map['operation_number'] as int,
      time: map['time'] as String,
      equipmentName: map['equipment_name'] as String,
      workingTime: map['working_time'] as int,
      timeStart: map['time_start'] as String,
      isUploaded: map['is_uploaded'] as bool,
      order: map['order'] as int,
      stageOperationId: map['stage_operation_id'] as int,
      stageMasterOperationId: map['stage_master_operation_id'] as int,
      // inventoryNumber: map['inventory_number'] as String,
      // stage: map['stage'] as String,
      // code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory OperatorsOperationsDTO.fromJson(String source) => OperatorsOperationsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
 }
