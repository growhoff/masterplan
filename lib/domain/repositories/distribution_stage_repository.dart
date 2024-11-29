import 'package:collection/collection.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/status_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/domain/mappers/distribution_stage_mapper.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';

import '../../presentation/pages/dispatcher/distribution_page/distribution_stage_model.dart';

class DistributionStageRepository {
  DistributionStageRepository();

  final _distributionStageTable = DistributionStageTable();
  final _distributionStageMapper = DistributionStageMapper();

  Future<List<DistributionStage>>
      fetchChiefDistributionStagesByUnitIdOrderedByPriority(int unitId) async {
    final fetchedList = await _distributionStageTable.selectByUnitId(unitId);

    List<DistributionStageDto> dtosList = [];

    DistributionStageDto prevStage = DistributionStageDto(
        id: 0,
        chiefBatchId: 0,
        stageId: 0,
        statusId: 0,
        stageStatus: StatusDTO(id: 0, name: ''));

    for (var fetchedDistributionStage in fetchedList) {
      final distributionStageDto =
          DistributionStageDto.fromMap(fetchedDistributionStage);

      print(
          'prev chiefbatchID: ${prevStage.chiefBatchId}, status: ${prevStage.statusId}');
      print(
          '${distributionStageDto.chiefBatchDto?.batch.order?.number}.${distributionStageDto.chiefBatchDto?.batch.number}.${distributionStageDto.stageDto?.number} stage: ${distributionStageDto.chiefBatchId}');

      if (distributionStageDto.chiefBatchId != prevStage.chiefBatchId ||
          prevStage.statusId == 4) {
        dtosList.add(distributionStageDto);
      }
      prevStage = distributionStageDto;
    }
    print('перед ретерном');
    return _distributionStageMapper.listFromDto(dtosList);
  }

  Future<int> fetchQuantityOfUploadedDistributionStagesByBatchAndStageId(
      {required int batchId, required int stageId}) async {
    final fetchedList =
        await _distributionStageTable.selectNotUploadedByBatchIdAndStageId(
            batchId: batchId, stageId: stageId);

    return fetchedList.length;
  }

  Future<List<DistributionStage>> fetchDistributionStagesByBatchesList(
      List<int> batchesIdsList) async {
    List<DistributionStageDto> dtosList = [];

    final fetchedDistributionStagesList = await _distributionStageTable
        .selectByBatchesIdsListOrderedByChiefBatchAndStageId(batchesIdsList);

    for (final fetchedStage in fetchedDistributionStagesList) {
      final distributionStageDTO = DistributionStageDto.fromMap(fetchedStage);
      dtosList.add(distributionStageDTO);
    }
    return _distributionStageMapper.listFromDto(dtosList);
  }

  Future<List<DistributionStage>>
      fetchDistributionStagesByBatchesAndStagesIdsList(
          {required List<int> batchesIdsList,
          required List<int> stagesIdsList}) async {
    List<DistributionStageDto> dtosList = [];

    final fetchedDistributionStagesList =
        await _distributionStageTable.selectByBatchesAndStagesIdsList(
            batchesIdsList: batchesIdsList, stagesIdsList: stagesIdsList);

    for (final fetchedStage in fetchedDistributionStagesList) {
      final distributionStageDTO = DistributionStageDto.fromMap(fetchedStage);
      dtosList.add(distributionStageDTO);
    }
    return _distributionStageMapper.listFromDto(dtosList);
  }
}
