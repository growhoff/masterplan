// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';

class ItemMachineQueue {
  final Machine machine;
  final List<OperatorOperations> batchListQueue;
  final List<OperatorOperations> batchListReady;
  final int timeWorking;
  ItemMachineQueue({
    required this.machine,
    required this.batchListQueue,
    required this.batchListReady,
    required this.timeWorking,
  });
}
