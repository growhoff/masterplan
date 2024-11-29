// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';
import 'package:master_plan/domain/model/operator_operations.dart';

class ItemOperOp {
  final List<OperatorOperations> list;
  final List<int> listId;
  final bool? pause;
  final int idPath;
  final int machineId;
  final int statusId;
  final int order;
  final List<int> listChiefBatchId;
  final List<int> listChiefOperationId;
  final int? staffId;
  ItemOperOp({
    required this.list,
    required this.listId,
    this.pause,
    required this.idPath,
    required this.machineId,
    required this.statusId,
    required this.order,
    required this.listChiefBatchId,
    required this.listChiefOperationId,
    this.staffId,
  });
}
