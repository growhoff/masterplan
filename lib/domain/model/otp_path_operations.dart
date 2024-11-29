// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import './machine.dart';
import './operator_operations.dart';

class OptPathOperations {
  final List<OperatorOperations> list;
  final int idPath;
  final int? order;
  final int time;
  final Machine? machine;
  final AreaDTO? area;
  final List<int>? listId;
  final bool? active;
  final String batchNumber;
  final String stageNumber;
  // final bool isChoise;
  OptPathOperations({
    required this.list,
    required this.idPath,
    this.order,
    required this.time,
    this.machine,
    this.area,
    this.listId,
    this.active,
    required this.batchNumber,
    required this.stageNumber,
    // required this.isChoise,
  });
}
