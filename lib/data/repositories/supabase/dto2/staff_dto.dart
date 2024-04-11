import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

import '../dto/position_dto.dart';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class StaffDTO2 extends Dto {
  final int id;
  final String login;
  final String password;
  final int userId;
  final UserDTO2 userDTO;

  StaffDTO2(
      {required this.id,
      required this.login,
      required this.password,
      required this.userId,
      required this.userDTO});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'login': login,
      'password': password,
      'user_id': userId,
    };
  }

  factory StaffDTO2.fromMap(Map<String, dynamic> map) {
    return StaffDTO2(
        id: map['id'] as int,
        login: map['login'] as String,
        password: map['password'] as String,
        userId: map['user_id'] as int,
        userDTO: UserDTO2(
          id: map['z_user']['id'],
          fio: map['z_user']['fio'],
          positionId: map['z_user']['position_id'],
          areaId: map['z_user']['region_id'],
          companyId: map['z_user']['company_id'],
          photo: map['z_user']['photo'],
          unitId: map['z_user']['unit_id'],
          positionDTO: PositionDTO(
              id: map['z_user']['z_position']['id'],
              name: map['z_user']['z_position']['name']),
        ));
  }

  String toJson() => json.encode(toMap());

  factory StaffDTO2.fromJson(String source) =>
      StaffDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
}
