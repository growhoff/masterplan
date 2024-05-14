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

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'chiefBatchId': chiefBatchId,
      'stageId': stageId,
      'operationId': operationId,
      'chiefBatch': chiefBatch,
      'stage': stage,
      'operation': operation
    };
  }

  factory ChiefOperationDto.fromMap(Map<String, dynamic> map) {
    return ChiefOperationDto(
      id: map['id'] as int,
      operation: OperationDTO.fromMap(map['z_operation']),
      stage: StageDTO.fromMap(map['z_stage']),
      operationId: map['operation_id'],
      stageId: map['stage_id'],
      chiefBatch: ChiefBatchDTO.fromMap(map['z_chief_batch']),
      chiefBatchId: map['chief_batch_id'],
    );
  }
}
