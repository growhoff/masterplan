// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/change_dto.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/user.dart';

class ShiftsDistribution {
  final int id;
  final DateTime date;
  final User user;
  final ChangeDTO change;
  final Machine machine;
  ShiftsDistribution({
    required this.id,
    required this.date,
    required this.user,
    required this.change,
    required this.machine,
  });
  }
