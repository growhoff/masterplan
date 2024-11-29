// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/company_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';

import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class StaffDTO extends Dto {
  final int id;
  final String login;
  final String password;
  final String fio;
  final int? companyId;
  final CompanyDTO? company;
  final String? photo;
  final int positionId;
  final PositionDTO? position;

  StaffDTO({
    required this.id,
    required this.login,
    required this.password,
    required this.fio,
    this.photo,
    this.companyId,
    this.company,
    required this.positionId,
    this.position,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'password': password,
      'fio': fio,
      'company_id': companyId,
      'company': company?.toMap(),
      'photo': photo,
      'position_id': positionId,
      'position': position?.toMap(),
    };
  }

  factory StaffDTO.fromMap(Map<String, dynamic> map) {
    return StaffDTO(
      id: map['id'] as int,
      login: map['login'] as String,
      password: map['password'] as String,
      fio: map['fio'] as String,
      companyId: map['company_id'] != null ? map['company_id'] as int : null,
      company: map['z_company'] != null
          ? CompanyDTO.fromMap(map['z_company'] as Map<String, dynamic>)
          : null,
      photo: map['photo'] != null ? map['photo'] as String : null,
      positionId: map['position_id'] as int,
      position: map['z_position'] != null
          ? PositionDTO.fromMap(map['z_position'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory StaffDTO.fromJson(String source) =>
      StaffDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
