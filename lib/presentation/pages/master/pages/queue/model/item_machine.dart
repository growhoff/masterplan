// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';

class ItemMachine {
  final Machine machine;
  final List<OperatorOperations> listOper;
  final int time;
  ItemMachine({
    required this.machine,
    required this.listOper,
    required this.time,
  });

  ItemMachine copyWith({
    Machine? machine,
    List<OperatorOperations>? listOper,
    int? time,
  }) {
    return ItemMachine(
      machine: machine ?? this.machine,
      listOper: listOper ?? this.listOper,
      time: time ?? this.time,
    );
  }
}
