// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/domain/model/batch.dart';

class OperatorOperations {
  final int id;
  final int timeplan;
  final int timefact;
  final int timestart;
  final int timestop;
  final int timeworking;
  final StatusDTO status;
  final Batch batch;
  final UserDTO user;
  final bool isuploaded;
  final int order;
  final MachineDTO machine;

  OperatorOperations({
    required this.id,
    required this.timeplan,
    required this.timefact,
    required this.timestart,
    required this.timestop,
    required this.timeworking,
    required this.status,
    required this.batch,
    required this.user,
    required this.isuploaded,
    required this.order,
    required this.machine,

  });
}
