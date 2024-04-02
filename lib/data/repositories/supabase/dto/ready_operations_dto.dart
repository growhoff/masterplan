// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto/details_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/equipment_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ReadyOperationsDTO extends Dto {
  final int id;
  final int regionId;
  final int companyId;
  final int timePlan;
  final int timeFact;
  final int timeStart;
  final int timeStop;
  final StatusDTO statusId;
  final int stageOperationId;
  final DetailsDTO detailsId;
  final EquipmentDTO equipmentId;
  final UserDTO userId;
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
    required this.detailsId,
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
      'status_id': statusId.toMap(),
      'stage_operation_id': stageOperationId,
      'details_id': detailsId.toMap(),
      'equipment_id': equipmentId.toMap(),
      'user_id': userId.toMap(),
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
      statusId: StatusDTO.fromMap(map['f_status'] as Map<String,dynamic>),
      stageOperationId: map['stage_operation_id'] as int,
      detailsId: DetailsDTO.fromMap(map['f_details'] as Map<String,dynamic>),
      equipmentId: EquipmentDTO.fromMap(map['f_equipment'] as Map<String,dynamic>),
      userId: UserDTO.fromMap(map['f_user'] as Map<String,dynamic>),
      isUploaded: map['is_uploaded'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory ReadyOperationsDTO.fromJson(String source) => ReadyOperationsDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
