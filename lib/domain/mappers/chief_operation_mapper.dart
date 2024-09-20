import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/domain/mappers/mapper.dart';
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
