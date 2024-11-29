import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/domain/model/chief_batch.dart';


class ChiefOperation {
  ChiefOperation(
      {required this.id,
      required this.stageId,
      required this.chiefBatchId,
        required this.chiefBatch,
      required this.operationId,
        required this.operation,
      required this.distributionStageId,
      required this.isDistributed});

  final int id;
  final int chiefBatchId;
  final ChiefBatch chiefBatch;
  final int stageId;
  final int operationId;
  final OperationDTO operation;
  final bool isDistributed;
  final int distributionStageId;
}
