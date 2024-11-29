// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/change_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';
import 'package:intl/intl.dart';

class ShiftsDistributionDTO extends Dto {
  final int id;
  final DateTime date;
  final StaffDTO? user;
  final ChangeDTO? change;
  final MachineDTO? machine;
  final int userId;
  final int changeId;
  final int machineId;
  ShiftsDistributionDTO({
    required this.id,
    required this.date,
    required this.user,
    required this.change,
    required this.machine,
    required this.userId,
    required this.changeId,
    required this.machineId,
  });


  Map<String, Object> toMap() {
    return <String, Object>{
      'date': DateFormat('yyyy-MM-dd').format(date),
      'staff_id': userId,
      'change_id': changeId,
      'machine_id': machineId,
    };
  }

  factory ShiftsDistributionDTO.fromMap(Map<String, dynamic> map) {
    final listTime = (map['date'] as String).split('-');
    return ShiftsDistributionDTO(
      id: map['id'] as int,
      date: DateTime.tryParse(map['date'] as String) ?? DateTime(int.parse(listTime[0]), int.parse(listTime[1]), int.parse(listTime[2])),
      user: StaffDTO.fromMap(map['z_staff'] as Map<String,dynamic>),
      change: ChangeDTO.fromMap(map['z_change'] as Map<String,dynamic>),
      machine: MachineDTO.fromMap(map['z_machine'] as Map<String,dynamic>),
      userId: map['staff_id'] as int,
      changeId: map['change_id'] as int,
      machineId: map['machine_id'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftsDistributionDTO.fromJson(String source) => ShiftsDistributionDTO.fromMap(json.decode(source) as Map<String, dynamic>);
  }
