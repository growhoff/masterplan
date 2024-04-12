// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';

class ItemMachineQueue {
  final Machine machine;
  final List<Batch> batchListQueue;
  final List<Batch> batchListOthers;
  final int timeWorking;
  ItemMachineQueue({
    required this.machine,
    required this.batchListQueue,
    required this.batchListOthers,
    required this.timeWorking,
  });
}
