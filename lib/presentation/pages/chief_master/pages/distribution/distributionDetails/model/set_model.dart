// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:master_plan/data/repositories/supabase/dto/operator_operations_dto.dart';

class SetModelBatch {
  final int chiefBatchId;
  final int batchId;
  final List<OperatorOperationsDTO> list;
  SetModelBatch({
    required this.chiefBatchId,
    required this.batchId,
    required this.list,
  });
}
