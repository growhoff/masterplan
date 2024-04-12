// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
import 'package:master_plan/domain/model/operator_operations.dart';

class PageItem {
  final Machine machine;
  final List<OperatorOperations> operList;
  final int time;
  PageItem({
    required this.machine,
    required this.operList,
    required this.time,
  });
}
