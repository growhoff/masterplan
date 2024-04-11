// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

import '../dto/position_dto.dart';

class UserDTO2 extends Dto {
  final int id;
  final String fio;
  final int? positionId;
  final int companyId;
  final int? unitId;
  final int? areaId;
  final String? photo;
  final PositionDTO? positionDTO;

  UserDTO2(
      {required this.id,
      required this.fio,
      required this.positionId,
      required this.companyId,
      required this.unitId,
      required this.areaId,
      required this.photo,
      required this.positionDTO});

  UserDTO2.init(
      {this.id = 0,
      this.fio = 'none',
      this.positionId = 0,
      this.companyId = 0,
      this.areaId = 0,
      this.unitId = 0,
      this.photo = '',
      this.positionDTO});

  static final empty = UserDTO2(
      id: 0,
      fio: '',
      positionId: 0,
      companyId: 0,
      unitId: 0,
      areaId: 0,
      photo: '',
      positionDTO: PositionDTO(id: 0, name: ''));

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

  factory UserDTO2.fromMap(Map<String, dynamic> map) {
    return UserDTO2(
      id: map['id'] as int,
      fio: map['fio'] as String,
      positionId: map['position_id'] as int,
      companyId: map['company_id'] as int,
      unitId: map['unit_id'] == null ? null : map['unit_id'] as int,
      areaId: map['area_id'] == null ? null : map['area_id'] as int,
      photo: map['photo'],
      positionDTO: PositionDTO(
          id: map['z_position']['id'], name: map['z_position']['name']),
    );
  }

  String toJson() => json.encode(toMap());

  factory UserDTO2.fromJson(String source) =>
      UserDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
