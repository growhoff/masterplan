// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';

class Area {
  final int id;
  final String name;
  final String number;
  final List<Machine> machineList;
  final List<int> machineListId;
  Area({
    required this.id,
    required this.name,
    required this.number,
    required this.machineList,
    required this.machineListId,
  });
}
