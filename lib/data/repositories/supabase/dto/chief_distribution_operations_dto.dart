import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

class ChiefDistributionOperationsDTO extends Dto {
  final int id;
  final int stageId;
  final StageDTO stage;
  final int operationId;
  final OperationDTO operation;
  final int batchId;
  final BatchDTO batch;
  final int quantity;
  final int? unitId;

  ChiefDistributionOperationsDTO(
      {required this.id,
      required this.operationId,
      required this.stageId,
      required this.stage,
      required this.operation,
      required this.batchId,
      required this.batch,
      required this.quantity,
      this.unitId});

  factory ChiefDistributionOperationsDTO.fromMap(Map<String, dynamic> map) {
    return ChiefDistributionOperationsDTO(
        id: map['id'],
        stageId: map['stage_id'],
        stage: StageDTO.fromMap(map['z_stage']),
        operationId: map['operation_id'],
        operation: OperationDTO.fromMap(map['z_operation']),
        quantity: map['quantity'],
        batchId: map['batch_id'],
        unitId: map['unit_id'],
        batch: BatchDTO.fromMap(map['z_batch']));
  }
}
