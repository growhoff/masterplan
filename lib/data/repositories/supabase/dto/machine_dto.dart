// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/control_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shift_schedule_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/type_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/view_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class MachineDTO extends Dto {
  final int id;
  final int inventoryNumber;
  final String name;
  final int areaId;
  final bool isActivated;
  final AreaDTO? area;
  final String? model;
  final String? prefix;
  final int? shiftScheduleId;
  final int? viewId;
  final int? controlId;
  final int? typeMachineId;
  final ShiftScheduleDTO? shiftSchedule;
  final ViewMachineDTO? viewMachine;
  final ControlMachineDTO? controlMachine;
  final TypeMachineDTO? typeMachine;
  MachineDTO({
    required this.id,
    required this.inventoryNumber,
    required this.name,
    required this.areaId,
    required this.isActivated,
    this.area,
    this.model,
    this.prefix,
    this.shiftScheduleId,
    this.viewId,
    this.controlId,
    this.typeMachineId,
    this.shiftSchedule,
    this.viewMachine,
    this.controlMachine,
    this.typeMachine,
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
      model: map['model'] != null ? map['model'] as String : null,
      prefix: map['prefix'] != null ? map['prefix'] as String : null,
      shiftScheduleId: map['shift_schedule_id'] != null ? map['shift_schedule_id'] as int : null,
      shiftSchedule: map['z_shift_schedule'] != null ?  ShiftScheduleDTO.fromMap(map['z_shift_schedule']) : null,

      viewId: map['view_id'] != null ? map['view_id'] as int : null,
      viewMachine: map['z_view_machine'] != null ?  ViewMachineDTO.fromMap(map['z_view_machine']) : null,
      controlId: map['control_id'] != null ? map['control_id'] as int : null,
      controlMachine: map['z_control_machine'] != null ?  ControlMachineDTO.fromMap(map['z_control_machine']) : null,
      typeMachineId: map['type_machine_id'] != null ? map['type_machine_id'] as int : null,
      typeMachine: map['z_type_machine'] != null ?  TypeMachineDTO.fromMap(map['z_type_machine']) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory MachineDTO.fromJson(String source) =>
      MachineDTO.fromMap(json.decode(source) as Map<String, dynamic>);
}
