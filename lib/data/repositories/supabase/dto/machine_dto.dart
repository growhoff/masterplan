// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shift_schedule_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class MachineDTO extends Dto {
  final int id;
  final int inventoryNumber;
  final String name;
  final int areaId;
  final bool isActivated;
  final AreaDTO? area;
  final String? typeMachine;
  final String? model;
  final String? control;
  final String? prefix;
  final int? shiftScheduleId;
  final ShiftScheduleDTO? shiftSchedule;

  MachineDTO({
    required this.id,
    required this.inventoryNumber,
    required this.name,
    required this.areaId,
    required this.isActivated,
    this.area,
    this.typeMachine,
    this.model,
    this.control,
    this.prefix,
    this.shiftScheduleId,
    this.shiftSchedule,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'inventory_number': inventoryNumber,
      'name': name,
      'area_id': areaId,
    };
  }

  factory MachineDTO.fromMap(Map<String, dynamic> map) {
    return MachineDTO(
      id: map['id'] as int,
      inventoryNumber: map['inventory_number'] as int,
      name: map['name'] as String,
      isActivated: map['is_activated'],
      areaId: map['area_id'] as int,
      area: map['z_area'] != null ? AreaDTO.fromMap(map['z_area']) : null,
      typeMachine: map['type_machine'] != null ? map['type_machine'] as String : null,
      model: map['model'] != null ? map['model'] as String : null,
      control: map['control'] != null ? map['control'] as String : null,
      prefix: map['prefix'] != null ? map['prefix'] as String : null,
      shiftScheduleId: map['shift_schedule_id'] != null ? map['shift_schedule_id'] as int : null,
      shiftSchedule: map['z_shift_schedule'] != null ?  ShiftScheduleDTO.fromMap(map['z_shift_schedule']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineDTO.fromJson(String source) =>
      MachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
