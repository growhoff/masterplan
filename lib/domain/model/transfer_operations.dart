// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class TransferOperations extends Dto {
  final int id;
  final bool? pause;
  final int? timeFirstStart;
  final int? timestart;
  final int? timestop;
  final int? timeworking;
  final StaffDTO? staff;
  final BatchDTO batch;
  final MachineDTO? machine;
  final OperationDTO operation;
  final ChiefOperationDto? chiefOperation;

  TransferOperations({
    required this.id,
    this.pause,
    this.timeFirstStart,
    this.timestart,
    this.timestop,
    this.timeworking,
    this.staff,
    required this.batch,
    this.machine,
    required this.operation,
    this.chiefOperation,
  });
}
