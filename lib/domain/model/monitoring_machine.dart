// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_machine_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';

class MonitoringMachine {
  final int? id;
  final int timeStart;
  final int timeStop;
  final int? timeWorking;
  final StatusMachineDTO? statusMachine;
  final StaffDTO? user;
  final MachineDTO? machine;
  final BatchDTO? batch;
  final String? comment;
  final DateTime date;
  final int changeId;
  final int? operationId;
  final int? firstStartBatch;
  MonitoringMachine({
    this.id,
    required this.timeStart,
    required this.timeStop,
    this.timeWorking,
    this.statusMachine,
    this.user,
    this.machine,
    this.batch,
    this.comment,
    required this.date,
    required this.changeId,
    this.operationId,
    this.firstStartBatch,
  });
}
