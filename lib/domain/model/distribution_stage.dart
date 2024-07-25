import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/stage.dart';
import 'package:master_plan/domain/model/user.dart';

import '../../data/repositories/supabase/dto/stage_status.dart';
import 'batch.dart';

class DistributionStage {
  DistributionStage({
    required this.id,
    required this.chiefBatchId,
    this.chiefBatch,
    required this.stageId,
    this.stage,
    required this.statusId,
    this.unitId,
    this.stageStatus
  });

  final int id;
  final int chiefBatchId;
  final ChiefBatch? chiefBatch;
  final int stageId;
  final Stage? stage;
  final int statusId;
  final int? unitId;
  final StageStatus? stageStatus;

  factory DistributionStage.fromDto(DistributionStageDto dto) {
    return DistributionStage(
        id: dto.id,
        chiefBatchId: dto.chiefBatchId,
        stageId: dto.stageId,
        statusId: dto.statusId,
        stageStatus: dto.stageStatus,
        unitId: dto.unitId,
        chiefBatch: dto.chiefBatchDto != null
            ? ChiefBatch(
                id: 0,
                batchStatusId: dto.chiefBatchDto?.batchStatusId,
                batchId: dto.chiefBatchDto?.batchId ?? 0,
                batch: dto.chiefBatchDto?.batch ??
                    BatchDTO(
                        id: dto.chiefBatchDto?.batch.id ?? 0,
                        number: dto.chiefBatchDto?.batch.number ?? '',
                        name: dto.chiefBatchDto?.batch.name ?? '',
                        count: dto.chiefBatchDto?.batch.count ?? 0,
                        code: dto.chiefBatchDto?.batch.code ?? '',
                        technology: dto.chiefBatchDto?.batch.technology ?? '',

                        isready: dto.chiefBatchDto?.batch.isready ?? false,
                        orderId: dto.chiefBatchDto?.orderId,
                        batchArchiveId:
                            dto.chiefBatchDto?.batch.batchArchiveId))
            : null,
        stage: dto.stageDto != null
            ? Stage(
                id: dto.stageDto?.id ?? 0,
                number: dto.stageDto?.number ?? '',
                name: dto.stageDto?.name ?? '',
                areaId: dto.stageDto?.areaId ?? 0,
                isdistributed: dto.stageDto?.isdistributed ?? false,
                batchId: dto.chiefBatchId,
              )
            : null);
  }
}
