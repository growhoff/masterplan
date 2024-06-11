// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/presentation/pages/master/pages/readyDetails/model/item_oper.dart';

class ItemMachine {
  final Machine machine;
  final List<ItemOperReady> listOper;
  final int time;
  ItemMachine({
    required this.machine,
    required this.listOper,
    required this.time,
  });

  ItemMachine copyWith({
    Machine? machine,
    List<ItemOperReady>? listOper,
    int? time,
  }) {
    return ItemMachine(
      machine: machine ?? this.machine,
      listOper: listOper ?? this.listOper,
      time: time ?? this.time,
    );
  }
}
