// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/batch.dart';
import 'package:master_plan/domain/model/machine.dart';

class ItemMachine {
  final Machine machine;
  final List<Batch> batchList;
  final int timeWorking;
  ItemMachine({
    required this.machine,
    required this.batchList,
    required this.timeWorking,
  });
}
