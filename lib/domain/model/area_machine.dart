// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/machine.dart';

class AreaMachine {
  final Area area;
  final List<Machine> listMachine;
  final List<int> idListMachine;
  AreaMachine({
    required this.area,
    required this.listMachine,
    required this.idListMachine,
  });
}
