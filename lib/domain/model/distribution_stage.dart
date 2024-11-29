import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/stage.dart';
import 'package:master_plan/domain/model/status.dart';
import 'package:master_plan/domain/model/unit.dart';
// import 'package:master_plan/domain/model/user.dart';

import '../../data/repositories/supabase/dto/stage_status.dart';
// import 'batch.dart';

class DistributionStage {
  DistributionStage(
      {required this.id,
      required this.chiefBatchId,
      this.chiefBatch,
      required this.stageId,
      this.stage,
      required this.statusId,
      this.unit,
      this.unitId,
      this.stageStatus});

  final int id;
  final int chiefBatchId;
  final ChiefBatch? chiefBatch;
  final int stageId;
  final Stage? stage;
  final int statusId;
  final int? unitId;
  final Unit? unit;
  final Status? stageStatus;

  factory DistributionStage.fromDto(DistributionStageDto dto) {
    return DistributionStage(
        id: dto.id,
        chiefBatchId: dto.chiefBatchId,
        stageId: dto.stageId,
        statusId: dto.statusId,
        unit: Unit(
            id: dto.unitDto?.id ?? 0,
            companyId: dto.unitDto?.companyId ?? 0,
            number: dto.unitDto?.number),
        stageStatus: Status(
            id: dto.stageStatus?.id ?? 0, name: dto.stageStatus?.name ?? ''),
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
                        order: OrderDTO(
                            id: dto.chiefBatchDto?.batch.order?.id ?? 0,
                            number:
                                dto.chiefBatchDto?.batch.order?.number ?? '',
                            priority:
                                dto.chiefBatchDto?.batch.order?.priority ?? 0,
                            statusId:
                                dto.chiefBatchDto?.batch.order?.statusId ?? 0),
                        code: dto.chiefBatchDto?.batch.code ?? '',
                        technology: dto.chiefBatchDto?.batch.technology ?? '',

                        orderId: dto.chiefBatchDto?.orderId,
                        numberRS: dto.chiefBatchDto?.batch.numberRS ?? ''))
            : null,
        stage: dto.stageDto != null
            ? Stage(
                id: dto.stageDto?.id ?? 0,
                number: dto.stageDto?.number ?? '',
                name: dto.stageDto?.name ?? '',
                areaId: dto.stageDto?.areaId ?? 0,
                batchId: dto.chiefBatchId,
              )
            : null);
  }
}
