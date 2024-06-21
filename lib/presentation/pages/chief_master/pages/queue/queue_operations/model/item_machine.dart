// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';
// import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
// import '../model/item_oper.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';


class ItemMachine {
  final Machine machine;
  final List<OptPathOperations> listOper;
  final int time;
  ItemMachine({
    required this.machine,
    required this.listOper,
    required this.time,
  });

  ItemMachine copyWith({
    Machine? machine,
    List<OptPathOperations>? listOper,
    int? time,
    AreaDTO? area,
  }) {
    return ItemMachine(
      machine: machine ?? this.machine,
      listOper: listOper ?? this.listOper,
      time: time ?? this.time,
    );
  }
}
