// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';

import 'item_machine.dart';


class ItemMachineMonitor {

  final Machine machine;
  final List<ItemMachineStatus> listStatus;
  final int allTime;

  ItemMachineMonitor({
    required this.machine,
    required this.listStatus,
    required this.allTime,
  });

}
