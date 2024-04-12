// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_machine.dart';

class ZArea {
  final int id;
  final String name;
  final String number;
  final List<ZMachine> machineList;
  final List<int> machineListId;
  ZArea({
    required this.id,
    required this.name,
    required this.number,
    required this.machineList,
    required this.machineListId,
  });
}
