// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:master_plan/data/repositories/supabase/dto/shift_schedule_dto.dart';

class Machine{
  final int id;
  final int inventoryNumber;
  final String name;
  final int areaId;
  final bool isActivated;
  final String? typeMachine;
  final String? model;
  final String? control;
  final String? prefix;
  final ShiftScheduleDTO? shiftSchedule;
  Machine({
    required this.id,
    required this.inventoryNumber,
    required this.name,
    required this.areaId,
    required this.isActivated,
    this.typeMachine,
    this.model,
    this.control,
    this.prefix,
    this.shiftSchedule,
  });
}
