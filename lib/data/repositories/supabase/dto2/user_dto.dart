// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto2/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class UserDTO2 extends Dto {
  final int id;
  final String fio;
  final PositionDTO2 position;
  final CompanyDTO2 company;
  final UnitDTO2? unit;
  final AreaDTO2? area;
  final int positionId;
  final int companyId;
  final int? unitId;
  final int? areaId;
  final String? photo;
  UserDTO2({
    required this.id,
    required this.fio,
    required this.position,
    required this.company,
    this.unit,
    this.area,
    required this.positionId,
    required this.companyId,
    this.unitId,
    this.areaId,
    this.photo,
  });

  static final  empty = UserDTO2(
      id: 0,
      fio: '',
      positionId: 0,
      companyId: 0,
      unitId: 0,
      areaId: 0,
      photo: '',
      position: PositionDTO2(id: 0, name: ''),
      company: CompanyDTO2.init());

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fio': fio,
      'position': position.toMap(),
      'company': company.toMap(),
      'unit': unit?.toMap(),
      'area': area?.toMap(),
      'position_id': positionId,
      'company_id': companyId,
      'unit_id': unitId,
      'area_id': areaId,
      'photo': photo,
    };
  }

  factory UserDTO2.fromMap(Map<String, dynamic> map) {
    return UserDTO2(
      id: map['id'] as int,
      fio: map['fio'] as String,
      position: PositionDTO2.fromMap(map['z_position'] as Map<String,dynamic>),
      company: CompanyDTO2.fromMap(map['z_company'] as Map<String,dynamic>),
      unit: map['z_unit'] != null ? UnitDTO2.fromMap(map['z_unit'] as Map<String,dynamic>) : null,
      area: map['z_area'] != null ? AreaDTO2.fromMap(map['z_area'] as Map<String,dynamic>) : null,
      positionId: map['position_id'] as int,
      companyId: map['company_id'] as int,
      unitId: map['unit_id'] != null ? map['unit_id'] as int : null,
      areaId: map['area_id'] != null ? map['area_id'] as int : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDTO2.fromJson(String source) => UserDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
