import 'package:collection/collection.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/domain/mappers/distribution_stage_mapper.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';

class DistributionStageRepository {
  DistributionStageRepository();

  final _distributionStageTable = DistributionStageTable();
  final _distributionStageMapper = DistributionStageMapper();

  Future<List<DistributionStage>>
      fetchChiefDistributionStagesByUnitIdOrderedByPriority(int unitId) async {
    final fetchedList = await _distributionStageTable.selectByUnitId(unitId);

    List<DistributionStageDto> dtosList = [];

    for (var fetchedDistributionStage in fetchedList) {
      final distributionStageDto =
          DistributionStageDto.fromMap(fetchedDistributionStage);
      dtosList.add(distributionStageDto);
    }



    return _distributionStageMapper.listFromDto(dtosList);
  }
}
