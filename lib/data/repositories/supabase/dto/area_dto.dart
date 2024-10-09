// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class AreaDTO extends Dto {
  final int id;
  final String name;
  final String number;
  final int unitId;
  final UnitDTO? unit;
  final int? companyId;

  AreaDTO(
      {required this.id,
      required this.name,
      required this.number,
      required this.unitId,
      this.unit,
      this.companyId});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'number': number,
      'unit_id': unitId,
    };
  }

  factory AreaDTO.fromMap(Map<String, dynamic> map) {
    return AreaDTO(
      id: map['id'] as int,
      name: map['name'] as String,
      number: map['number'] as String,
      unitId: map['unit_id'] as int,
      unit: map['z_unit'] != null ? UnitDTO.fromMap(map['z_unit']) : null,
      companyId: map['company_id'] != null ? map['company_id'] : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AreaDTO.fromJson(String source) =>
      AreaDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
