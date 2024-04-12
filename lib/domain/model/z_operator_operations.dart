// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto2/machine_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto2/user_dto.dart';
import 'package:master_plan/domain/model/z_batch.dart';

class ZOperatorOperations {
  final int id;
  final int timeplan;
  final int timefact;
  final int timestart;
  final int timestop;
  final int timeworking;
  final StatusDTO2 status;
  final int stageoperationid;
  final int stagemasteroperationid;
  final ZBatch batch;
  final UserDTO2 user;
  final bool isuploaded;
  final int order;
  final MachineDTO2 machine;
  ZOperatorOperations({
    required this.id,
    required this.timeplan,
    required this.timefact,
    required this.timestart,
    required this.timestop,
    required this.timeworking,
    required this.status,
    required this.stageoperationid,
    required this.stagemasteroperationid,
    required this.batch,
    required this.user,
    required this.isuploaded,
    required this.order,
    required this.machine,
  });
}
