// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/change_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ZShiftsDistributionDTO extends Dto {
  final int id;
  final DateTime date;
  final UserDTO user;
  final ChangeDTO change;
  final MachineDTO machine;
  ZShiftsDistributionDTO({
    required this.id,
    required this.date,
    required this.user,
    required this.change,
    required this.machine,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'user_id': user.toMap(),
      'change_id': change.toMap(),
      'machine_id': machine.toMap(),
    };
  }

  factory ZShiftsDistributionDTO.fromMap(Map<String, dynamic> map) {
    final listTime = (map['date'] as String).split('-');
    return ZShiftsDistributionDTO(
      id: map['id'] as int,
      date: DateTime.tryParse(map['date'] as String) ?? DateTime(int.parse(listTime[0]), int.parse(listTime[1]), int.parse(listTime[2])),
      user: UserDTO.fromMap(map['z_user'] as Map<String,dynamic>),
      change: ChangeDTO.fromMap(map['z_change'] as Map<String,dynamic>),
      machine: MachineDTO.fromMap(map['z_machine'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZShiftsDistributionDTO.fromJson(String source) => ZShiftsDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
