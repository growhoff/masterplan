import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/order_dto.dart';
import 'package:master_plan/domain/mappers/mapper.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/stage.dart';
import 'package:master_plan/domain/model/status.dart';

import '../model/distribution_stage.dart';

class DistributionStageMapper
    extends Mapper<DistributionStageDto, DistributionStage> {
  @override
  DistributionStage fromDto(DistributionStageDto dto) {
    return DistributionStage(
        id: dto.id,
        chiefBatchId: dto.chiefBatchId,
        stageId: dto.stageId,
        unitId: dto.unitId,
        stage: Stage(
            id: dto.stageDto?.id ?? 0,
            number: dto.stageDto?.number ?? '',
            name: dto.stageDto?.name ?? ''),
        statusId: dto.statusId,
        stageStatus: Status(
            id: dto.stageStatus?.id ?? 0, name: dto.stageStatus?.name ?? ''),
        chiefBatch: ChiefBatch(
            id: dto.chiefBatchDto?.id ?? 0,
            batchId: dto.chiefBatchDto?.batchId ?? 0,
            batch: BatchDTO(
                id: dto.chiefBatchDto?.batch.id ?? 0,
                numberRS: dto.chiefBatchDto?.batch.numberRS ?? '',
                number: dto.chiefBatchDto?.batch.number ?? '',
                name: dto.chiefBatchDto?.batch.name ?? '',
                count: dto.chiefBatchDto?.batch.count ?? 0,
                code: dto.chiefBatchDto?.batch.code ?? '',
                technology: dto.chiefBatchDto?.batch.technology ?? '',
                orderId: dto.chiefBatchDto?.batch.orderId ?? 0,
                order: OrderDTO(
                    id: dto.chiefBatchDto?.batch.order?.id ?? 0,
                    number: dto.chiefBatchDto?.batch.order?.number ?? '',
                    priority: dto.chiefBatchDto?.batch.order?.priority ?? 0,
                    statusId: dto.chiefBatchDto?.batch.order?.statusId ?? 0))));
  }

  @override
  List<DistributionStage> listFromDto(List<DistributionStageDto> dtosList) {
    List<DistributionStage> distributionStagesList = [];

    for (var dto in dtosList) {
      final stage = fromDto(dto);
      distributionStagesList.add(stage);
    }

    return distributionStagesList;
  }
}
