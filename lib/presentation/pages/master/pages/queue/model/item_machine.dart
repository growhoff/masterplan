// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/otp_path_operations.dart';
// import 'package:master_plan/presentation/pages/master/pages/queue/model/item_oper.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';


class ItemMachine {
  final Machine machine;
  final List<OptPathOperations> listOper;
  final OptPathOperations? activeOper;
  final int time;
  ItemMachine({
    required this.machine,
    required this.listOper,
    this.activeOper,
    required this.time,
  });

  ItemMachine copyWith({
    Machine? machine,
    List<OptPathOperations>? listOper,
    OptPathOperations? activeOper,
    int? time,
  }) {
    return ItemMachine(
      machine: machine ?? this.machine,
      listOper: listOper ?? this.listOper,
      activeOper: activeOper ?? this.activeOper,
      time: time ?? this.time,
    );
  }
}
