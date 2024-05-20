import 'package:master_plan/data/repositories/supabase/dto/chief_batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ChiefOperationDto extends Dto {
  ChiefOperationDto(
      {required this.id, this.operation,
       this.stage,
      required this.operationId,
      required this.stageId, this.chiefBatch,
      required this.chiefBatchId});

  final int id;
  final int chiefBatchId;
  final int stageId;
  final int operationId;
  final ChiefBatchDTO? chiefBatch;
  final StageDTO? stage;
  final OperationDTO? operation;

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
      operation: map['z_operation'] != null ? OperationDTO.fromMap(map['z_operation']) : null,
      stage: map['z_stage'] != null ? StageDTO.fromMap(map['z_stage']) : null,
      operationId: map['operation_id'],
      stageId: map['stage_id'],
      chiefBatch:map['z_chief_batch'] != null ? ChiefBatchDTO.fromMap(map['z_chief_batch']) : null,
      chiefBatchId: map['chief_batch_id'],
    );
  }
}
