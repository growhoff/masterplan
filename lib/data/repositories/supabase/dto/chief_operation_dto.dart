import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ChiefOperationDto extends Dto {
  ChiefOperationDto(
      {required this.id,
      required this.operation,
      required this.stage,
      required this.operationId,
      required this.stageId,
      required this.chiefBatch,
      required this.chiefBatchId});

  final int id;
  final int chiefBatchId;
  final int stageId;
  final int operationId;
  final ChiefBatchDTO chiefBatch;
  final StageDTO stage;
  final OperationDTO operation;
}
