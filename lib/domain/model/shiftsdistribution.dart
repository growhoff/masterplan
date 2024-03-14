// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/change.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/equipment.dart';
import 'package:master_plan/domain/model/region.dart';
import 'package:master_plan/domain/model/user_lite.dart';

class ShiftsDistribution {
  final int id;
  final ChangeModel change;
  final DateTime date;
  final Equipment equipment;
  final UserModelLite user;
  final Region region;
  final Company company;
  ShiftsDistribution({
    required this.id,
    required this.change,
    required this.date,
    required this.equipment,
    required this.user,
    required this.region,
    required this.company,
  });
}
