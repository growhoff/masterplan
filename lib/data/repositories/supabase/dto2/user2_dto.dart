// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto2/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class User2DTO2 extends Dto {
  final int id;
  final String fio;
  final int positionId;
  final int companyId;
  final int? unitId;
  final int? areaId;
  final String? photo;
  final PositionDTO2? positionDTO;
  User2DTO2({
    required this.id,
    required this.fio,
    required this.positionId,
    required this.companyId,
    this.unitId,
    this.areaId,
    this.photo,
    this.positionDTO
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fio': fio,
      'position_id': positionId,
      'company_id': companyId,
      'unit_id': unitId,
      'area_id': areaId,
      'photo': photo
    };
  }

  factory User2DTO2.fromMap(Map<String, dynamic> map) {
    return User2DTO2(
      id: map['id'] as int,
      fio: map['fio'] as String,
      positionId: map['position_id'] as int,
      companyId: map['company_id'] as int,
      unitId: map['unit_id'] != null ? map['unit_id'] as int : null,
      areaId: map['area_id'] != null ? map['area_id'] as int : null,
      photo: map['photo'],
      positionDTO: PositionDTO2(id: map['z_position']['id'], name: map['z_position']['name']),
    );
  }

  String toJson() => json.encode(toMap());

  factory User2DTO2.fromJson(String source) => User2DTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}