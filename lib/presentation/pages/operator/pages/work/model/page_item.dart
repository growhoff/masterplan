// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/domain/model/machine.dart';
// import 'package:master_plan/domain/model/operator_operations.dart';
import 'package:master_plan/presentation/pages/operator/pages/work/model/item_oper.dart';

class PageItem {
  final Machine machine;
  final List<ItemOperOp> operReadyList;
  final List<ItemOperOp> operQueueList;
  final ItemOperOp? operActive;
  PageItem({
    required this.machine,
    required this.operReadyList,
    required this.operQueueList,    
    this.operActive,
  });
}
