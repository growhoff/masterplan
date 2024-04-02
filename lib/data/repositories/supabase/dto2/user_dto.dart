// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UserDTO2 extends Dto {
  final int id;
  final String fio;
  final int positionId;
  final int companyId;
  final int? unitId;
  final int? areaId;
  UserDTO2({
    required this.id,
    required this.fio,
    required this.positionId,
    required this.companyId,
    required this.unitId,
    required this.areaId
  });
  UserDTO2.init({
    this.id = 0,
    this.fio = 'none',
    this.positionId = 0,
    this.companyId = 0,
    this.areaId = 0,
    this.unitId = 0
  });
 

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fio': fio,
      'position_id': positionId,
      'company_id': companyId,
      'unit_id': unitId,
      'area_id': areaId,
    };
  }

  factory UserDTO2.fromMap(Map<String, dynamic> map) {
    return UserDTO2(
      id: map['id'] as int,
      fio: map['fio'] as String,
      positionId: map['position_id'] as int,
      companyId: map['company_id'] as int,
      unitId: map['unit_id'] == null ? null : map['unit_id'] as int,
      areaId: map['area_id'] == null ? null : map['area_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDTO2.fromJson(String source) => UserDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
