// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/z_batch.dart';
import 'package:master_plan/domain/model/z_machine.dart';

class ItemMachineQueue {
  final ZMachine machine;
  final List<ZBatch> batchListQueue;
  final List<ZBatch> batchListOthers;
  final int timeWorking;
  ItemMachineQueue({
    required this.machine,
    required this.batchListQueue,
    required this.batchListOthers,
    required this.timeWorking,
  });
}
