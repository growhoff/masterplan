import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StstageDTO extends Dto {
  final int id;
  final String stageNumber;
  final int operationsQuentity;
  final int detailsQuentity;
  final String company;
  final String planNumber;
  final String planName;
  final bool isDistributed;
  // final String code;
  StstageDTO({
    required this.id,
    required this.stageNumber,
    required this.operationsQuentity,
    required this.detailsQuentity,
    required this.company,
    required this.planNumber,
    required this.planName,
    required this.isDistributed,
    // required this.code,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'stage_number': stageNumber,
      'operations_quantity': operationsQuentity,
      'details_quantity': detailsQuentity,
      'company': company,
      'plan_number': planNumber,
      'plan_name': planName,
      'is_distributed': isDistributed,
      // 'code': code,
    };
  }


  factory StstageDTO.fromMap(Map<String, dynamic> map) {
    return StstageDTO(
      id: map['id'] as int,
      stageNumber: map['stage_number'] as String,
      operationsQuentity: map['operations_quantity'] as int,
      detailsQuentity: map['details_quantity'] as int,
      company: map['company'] as String,
      planNumber: map['plan_number'] as String,
      planName: map['plan_name'] as String,
      isDistributed: map['is_distributed'] as bool,
      // code: map['code'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory StstageDTO.fromJson(String source) => StstageDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
