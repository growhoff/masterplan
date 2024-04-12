// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';

class ItemMachineStatus {
  final int timeStart;
  final int timeEnd;
  final int timeWorking;
  final StatusDTO status;
  ItemMachineStatus({
    required this.timeStart,
    required this.timeEnd,
    required this.timeWorking,
    required this.status,
  });

}
