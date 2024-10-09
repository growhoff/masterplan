import 'package:master_plan/data/repositories/supabase/dto/batch_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/operation_dto.dart';
import 'package:master_plan/domain/mappers/mapper.dart';
import 'package:master_plan/domain/model/chief_batch.dart';
import 'package:master_plan/domain/model/chief_operation.dart';

class ChiefOperationMapper extends Mapper<ChiefOperationDto, ChiefOperation> {
  @override
  ChiefOperation fromDto(ChiefOperationDto dto) {
    return ChiefOperation(
      id: dto.id,
      operationId: dto.operationId,
      stageId: dto.stageId,
      chiefBatchId: dto.chiefBatchId,
      distributionStageId: dto.distributionStageId ?? 0,
      isDistributed: dto.isDistributed ?? false,
      chiefBatch: ChiefBatch(
          id: dto.chiefBatch?.id ?? 0,
          batchId: dto.chiefBatch?.batchId ?? 0,
          batch: BatchDTO(
              id: dto.chiefBatch?.batch.id ?? 0,
              numberRS: dto.chiefBatch?.batch.numberRS ?? '',
              number: dto.chiefBatch?.batch.number ?? '',
              name: dto.chiefBatch?.batch.name ?? '',
              count: dto.chiefBatch?.batch.count ?? 0,
              code: dto.chiefBatch?.batch.code ?? '',
              technology: dto.chiefBatch?.batch.technology ?? '')),
      operation: OperationDTO(
          id: dto.operation?.id ?? 0,
          number: dto.operation?.number ?? '',
          name: dto.operation?.name ?? '',
          code: dto.operation?.code ?? '',
          timepz: dto.operation?.timepz ?? 0,
          stageId: dto.operation?.stageId ?? 0,
          timeSH: dto.operation?.timeSH ?? 0),
    );
  }

  @override
  List<ChiefOperation> listFromDto(List<ChiefOperationDto> dtosList) {
    List<ChiefOperation> chiefOperationsList = [];

    for (var dto in dtosList) {
      final operation = fromDto(dto);
      chiefOperationsList.add(operation);
    }

    return chiefOperationsList;
  }
}
