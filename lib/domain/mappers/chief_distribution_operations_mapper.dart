import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/domain/mappers/mapper.dart';
import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';

class ChiefDistributionOperationsMapper
    extends Mapper<ChiefDistributionOperationsDTO, ChiefDistributionOperation> {
  @override
  ChiefDistributionOperation fromDto(ChiefDistributionOperationsDTO dto) {
    return ChiefDistributionOperation(
        id: dto.id,
        operationId: dto.operationId,
        stageId: dto.stageId,
        stage: dto.stage,
        operation: dto.operation,
        batchId: dto.batchId,
        batch: dto.batch,
        quantity: dto.quantity);
  }

  @override
  List<ChiefDistributionOperation> listFromDto(List<ChiefDistributionOperationsDTO> dtosList) {
    List<ChiefDistributionOperation> distributionOperationsList = [];

    for (var dto in dtosList) {
      final operation = fromDto(dto);
      distributionOperationsList.add(operation);
    }

    return distributionOperationsList;
  }
}
