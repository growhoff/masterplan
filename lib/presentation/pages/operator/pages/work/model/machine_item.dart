// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_machine.dart';
import 'package:master_plan/domain/model/z_operator_operations.dart';

class MachineItem {
  final ZMachine machine;
  final List<ZOperatorOperations> operList;
  MachineItem({
    required this.machine,
    required this.operList,
  });
}
