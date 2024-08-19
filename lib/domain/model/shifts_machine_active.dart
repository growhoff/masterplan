// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:master_plan/data/repositories/supabase/dto/shifts_distribution_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/shifts_distribution.dart';
// import 'package:master_plan/domain/model/shifts_distribution.dart';

class ShiftsMachineActive {
  final Machine machine;
  final ShiftsDistribution? changeItem;
  ShiftsMachineActive({
    required this.machine,
    this.changeItem,
  });
}
