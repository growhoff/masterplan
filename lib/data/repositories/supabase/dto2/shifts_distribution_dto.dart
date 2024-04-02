// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:master_plan/data/repositories/supabase/dto2/change_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ZShiftsDistributionDTO2 extends Dto {
  final int id;
  final DateTime date;
  final UserDTO2 userId;
  final ChangeDTO2 changeId;
  final MachineDTO2 machineId;
  ZShiftsDistributionDTO2({
    required this.id,
    required this.date,
    required this.userId,
    required this.changeId,
    required this.machineId,
  });


  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'date': date.millisecondsSinceEpoch,
      'user_id': userId.toMap(),
      'change_id': changeId.toMap(),
      'machine_id': machineId.toMap(),
    };
  }

  factory ZShiftsDistributionDTO2.fromMap(Map<String, dynamic> map) {
    final listTime = (map['date'] as String).split('-');
    return ZShiftsDistributionDTO2(
      id: map['id'] as int,
      date: DateTime.tryParse(map['date'] as String) ?? DateTime(int.parse(listTime[0]), int.parse(listTime[1]), int.parse(listTime[2])),
      userId: UserDTO2.fromMap(map['z_user'] as Map<String,dynamic>),
      changeId: ChangeDTO2.fromMap(map['z_change'] as Map<String,dynamic>),
      machineId: MachineDTO2.fromMap(map['z_machine'] as Map<String,dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory ZShiftsDistributionDTO2.fromJson(String source) => ZShiftsDistributionDTO2.fromMap(json.decode(source) as Map<String, dynamic>);
  }
