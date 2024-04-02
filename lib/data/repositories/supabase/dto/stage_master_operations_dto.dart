// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto/st_stage_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/stage_distribution_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_distribution_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StageMasterOperationsDTO extends Dto {
  final int id;
  final int regionId;
  final int regionQuantity;
  final String company;
  final int distributionOperationId;
  final bool isDistributed;
  final List<int> operationsIdList;
  final int stageId;
  final int operationNumber;
  final StStageDistributionDTO stageDistribution;
  final StstageDTO ststage; 
  StageMasterOperationsDTO({
    required this.id,
    required this.regionId,
    required this.regionQuantity,
    required this.company,
    required this.distributionOperationId,
    required this.isDistributed,
    required this.operationsIdList,
    required this.stageId,
    required this.operationNumber,
    required this.stageDistribution,
    required this.ststage,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'region': regionId,
      'region_quantity': regionQuantity,
      'company': company,
      'distribution_operation_id': distributionOperationId,
      'isDistributed': isDistributed,
      'operations_id_list': operationsIdList,
      'stage_id': stageId,
      'operation_number': operationNumber,
      'stage_distribution_operation': stageDistribution.toMap(),
      'stage': ststage.toMap(),
    };
  }

  factory StageMasterOperationsDTO.fromMap(Map<String, dynamic> map) {
    return StageMasterOperationsDTO(
      id: map['id'] as int,
      regionId: map['region'] as int,
      regionQuantity: map['region_quantity'] as int,
      company: map['company'] as String,
      distributionOperationId: map['distribution_operation_id'] as int,
      isDistributed: map['isDistributed'] as bool,
      operationsIdList: (map['operations_id_list'] as List<dynamic>).map((e) => e as int).toList(),
      stageId: map['stage_id'] as int,
      operationNumber: map['operation_number'] as int,
      stageDistribution: StStageDistributionDTO.fromMap(map['stage_distribution_operation'] as Map<String,dynamic>),
      ststage: StstageDTO.fromMap(map['stage'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory StageMasterOperationsDTO.fromJson(String source) => StageMasterOperationsDTO.fromMap(json.decode(source) as Map<String, dynamic>);

}
