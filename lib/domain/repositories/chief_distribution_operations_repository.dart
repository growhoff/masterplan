import 'package:collection/collection.dart';
import 'package:master_plan/data/repositories/supabase/dto/chief_distribution_operations_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/distribution_stage_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_distribution_operations_table.dart';
import 'package:master_plan/data/repositories/supabase/service/distribution_stage_table.dart';
import 'package:master_plan/domain/mappers/distribution_stage_mapper.dart';
import 'package:master_plan/domain/model/chief_distribution_operations_model.dart';
import 'package:master_plan/domain/model/distribution_stage.dart';

import '../mappers/chief_distribution_operations_mapper.dart';

class ChiefDistributionOperationsRepository {
  ChiefDistributionOperationsRepository();

  final _chiefDistributionOperationsTable = ChiefDistributionOperationsTable();
  final _chiefDistributionOperationsMapper =
      ChiefDistributionOperationsMapper();

  Future<List<ChiefDistributionOperation>>
      fetchChiefDistributionOperationsByBatchAndStageId(
          {required int batchId, required int stageId}) async {
    final fetchedList = await _chiefDistributionOperationsTable
        .selectByBatchAndStageId(batchId: batchId, stageId: stageId);

    List<ChiefDistributionOperationsDTO> dtosList = [];

    for (var fetchedDistributionOperation in fetchedList) {
      final chiefDistributionOperationDto =
          ChiefDistributionOperationsDTO.fromMap(fetchedDistributionOperation);
      dtosList.add(chiefDistributionOperationDto);
    }

    return _chiefDistributionOperationsMapper.listFromDto(dtosList);
  }
}
