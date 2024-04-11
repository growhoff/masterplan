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
  UserDTO2({
    required this.id,
    required this.fio,
    required this.position,
    required this.company,
    this.unit,
    this.area,
  });

  String toJson() => json.encode(toMap());

  factory UserDTO2.fromJson(String source) => UserDTO2.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fio': fio,
      'position_id': position.toMap(),
      'company_id': company.toMap(),
      'unit_id': unit?.toMap(),
      'area_id': area?.toMap(),
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
    );
  }
}

  // UserDTO2.init({
  //   this.id = 0,
  //   this.fio = 'none',
  //   this.positionId = 0,
  //   this.companyId = 0,
  //   this.areaId = 0,
  //   this.unitId = 0
  // });
 


  // factory UserDTO2.fromMap(Map<String, dynamic> map) {
  //   return UserDTO2(
  //     id: map['id'] as int,
  //     fio: map['fio'] as String,
  //     positionId: map['z_position'] as int,
  //     companyId: map['z_company'] as int,
  //     unitId: map['z_unit'] == null ? null : map['z_unit'] as int,
  //     areaId: map['z_area'] == null ? null : map['z_area'] as int,
  //   );
  // }