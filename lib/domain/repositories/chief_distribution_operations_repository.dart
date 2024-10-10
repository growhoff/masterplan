import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';

import '../mappers/chief_distribution_operations_mapper.dart';

class ChiefDistributionOperationsRepository {
  ChiefDistributionOperationsRepository();

  final _chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
  final _chiefDistributionOperationsMapper =
      ChiefDistributionOperationsMapper();

  Future<List<ChiefDistributionOperation>> fetchByBatchAndStageId(
      {required int batchId, required int stageId}) async {
    final fetchedList = await _chiefDistributionOperationsTable
        .selectByBatchAndStageIdWithNotZeroQuantity(
            batchId: batchId, stageId: stageId);

    List<ChiefDistributionOperationsDTO> dtosList = [];

    for (var fetchedDistributionOperation in fetchedList) {
      final chiefDistributionOperationDto =
          ChiefDistributionOperationsDTO.fromMap(fetchedDistributionOperation);
      dtosList.add(chiefDistributionOperationDto);
    }

    return _chiefDistributionOperationsMapper.listFromDto(dtosList);
  }

  Future<List<ChiefDistributionOperation>> fetchByBatchId(int batchId) async {
    final fetchedList =
        await _chiefDistributionOperationsTable.selectByBatchAId(batchId);

    List<ChiefDistributionOperationsDTO> dtosList = [];

    for (var fetchedDistributionOperation in fetchedList) {
      final chiefDistributionOperationDto =
          ChiefDistributionOperationsDTO.fromMap(fetchedDistributionOperation);
      dtosList.add(chiefDistributionOperationDto);
    }

    return _chiefDistributionOperationsMapper.listFromDto(dtosList);
  }

  Future<List<ChiefDistributionOperation>> fetchByBatchesIdsList(
      List<int> batchIdsList) async {
    final fetchedList = await _chiefDistributionOperationsTable
        .selectByBatchesIdsLists(batchesIdsList: batchIdsList);

    List<ChiefDistributionOperationsDTO> dtosList = [];

    for (var fetchedDistributionOperation in fetchedList) {
      final chiefDistributionOperationDto =
          ChiefDistributionOperationsDTO.fromMap(fetchedDistributionOperation);
      dtosList.add(chiefDistributionOperationDto);
    }

    return _chiefDistributionOperationsMapper.listFromDto(dtosList);
  }

  Future<List<ChiefDistributionOperation>> fetchByBathesAndStagesIdsLists({
    required List<int> batchesIdsList,
  }) async {
    final fetchedList = await _chiefDistributionOperationsTable
        .selectByBatchesIdsListsWithNoZeroQuantity(batchesIdsList: batchesIdsList);

    List<ChiefDistributionOperationsDTO> dtosList = [];

    for (var fetchedDistributionOperation in fetchedList) {
      final chiefDistributionOperationDto =
          ChiefDistributionOperationsDTO.fromMap(fetchedDistributionOperation);
      dtosList.add(chiefDistributionOperationDto);
    }

    print('fetchByBathesAndStagesIdsLists');
    return _chiefDistributionOperationsMapper.listFromDto(dtosList);
  }
}
