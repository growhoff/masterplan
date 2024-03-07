import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class ShiftsDistributionDTO extends Dto{
  final int id;
  final int changeId;
  final DateTime data;
  final int equipmentId;
  final int userId;
  final int regionId;
  final int companyId;
  ShiftsDistributionDTO({
    required this.id,
    required this.changeId,
    required this.data,
    required this.equipmentId,
    required this.userId,
    required this.regionId,
    required this.companyId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'change_id': changeId,
      'data': data.millisecondsSinceEpoch,
      'equipment_id': equipmentId,
      'user_id': userId,
      'region_id': regionId,
      'company_id': companyId,
    };
  }

  factory ShiftsDistributionDTO.fromMap(Map<String, dynamic> map) {
    return ShiftsDistributionDTO(
      id: map['id'] as int,
      changeId: map['change_id'] as int,
      data: DateTime.fromMillisecondsSinceEpoch(map['data'] as int),
      equipmentId: map['equipment_id'] as int,
      userId: map['user_id'] as int,
      regionId: map['region_id'] as int,
      companyId: map['company_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftsDistributionDTO.fromJson(String source) => ShiftsDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
