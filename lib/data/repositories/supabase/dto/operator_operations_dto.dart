import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/details_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/equipment_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/region_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class OperatorOperationsDTO extends Dto {
  final int id;
  final int order;
  final RegionDTO regionId;
  final CompanyDTO companyId;
  final int time;
  final int timeStart;
  final int timeWorking;
  final StatusDTO statusId;
  final int stageOperationId;
  final int stageMasterOperationId;
  final EquipmentDTO equipmentId;
  final DetailsDTO detailsId;
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
      'region_id': regionId.toMap(),
      'company_id': companyId.toMap(),
      'time': time,
      'time_start': timeStart,
      'time_working': timeWorking,
      'status_id': statusId.toMap(),
      'stage_operation_id': stageOperationId,
      'stage_master_operation_id': stageMasterOperationId,
      'equipment_id': equipmentId.toMap(),
      'details_id': detailsId.toMap(),
    };
  }

  factory OperatorOperationsDTO.fromMap(Map<String, dynamic> map) {
    return OperatorOperationsDTO(
      id: map['id'] as int,
      order: map['order'] as int,
      regionId: RegionDTO.fromMap(map['f_region'] as Map<String,dynamic>),
      companyId: CompanyDTO.fromMap(map['f_company'] as Map<String,dynamic>),
      time: map['time'] as int,
      timeStart: map['time_start'] as int,
      timeWorking: map['time_working'] as int,
      statusId: StatusDTO.fromMap(map['f_status'] as Map<String,dynamic>),
      stageOperationId: map['stage_operation_id'] as int,
      stageMasterOperationId: map['stage_master_operation_id'] as int,
      equipmentId: EquipmentDTO.fromMap(map['f_equipment'] as Map<String,dynamic>),
      detailsId: DetailsDTO.fromMap(map['f_details'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory OperatorOperationsDTO.fromJson(String source) => OperatorOperationsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
