import '../../data/repositories/supabase/dto/batch_dto.dart';
import '../../data/repositories/supabase/dto/operation_dto.dart';
import '../../data/repositories/supabase/dto/stage_dto.dart';

class ChiefDistributionOperation {
  final int id;
  final int stageId;
  final StageDTO stage;
  final int operationId;
  final OperationDTO operation;
  final int batchId;
  final BatchDTO batch;
  int quantity = 0;

  ChiefDistributionOperation(
      {required this.id,
      required this.operationId,
      required this.stageId,
      required this.stage,
      required this.operation,
      required this.batchId,
      required this.batch,
      required this.quantity});
}
