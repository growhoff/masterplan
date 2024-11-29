// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:master_plan/data/repositories/supabase/dto/control_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/shift_schedule_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/type_machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/view_machine_dto.dart';
import 'package:master_plan/domain/model/area.dart';

class Machine{
  final int id;
  final int inventoryNumber;
  final String name;
  final int areaId;
  final bool isActivated;
  final String? model;
  final String? prefix;
  final ShiftScheduleDTO? shiftSchedule;
  final ViewMachineDTO? viewMachine;
  final ControlMachineDTO? controlMachine;
  final TypeMachineDTO? typeMachine;
  final int? shiftScheduleId;
  final int? viewMachineId;
  final int? controlMachineId;
  final int? typeMachineId;
  final Area? area;
  Machine({
    required this.id,
    required this.inventoryNumber,
    required this.name,
    required this.areaId,
    required this.isActivated,
    this.model,
    this.prefix,
    this.shiftSchedule,
    this.viewMachine,
    this.controlMachine,
    this.typeMachine,
    this.shiftScheduleId,
    this.viewMachineId,
    this.controlMachineId,
    this.typeMachineId,
    this.area,
  });
}
