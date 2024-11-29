import 'package:master_plan/data/repositories/supabase/dto/chief_operation_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/chief_operation_table.dart';
import 'package:master_plan/domain/mappers/chief_operation_mapper.dart';

import '../model/chief_operation.dart';

class ChiefOperationRepository {
  final _chiefOperationTable = ChiefOperationTable();
  final _chiefOperationMapper = ChiefOperationMapper();

  Future<List<ChiefOperation>> fetchOperationsByOperationIdWithLimit(
      {required int quantity, required int operationId}) async {
    var fetchedChiefOperationsList =
        await _chiefOperationTable.fetchOperationsByOperationIdWithLimit(
            limit: quantity, operationId: operationId);

    List<ChiefOperationDto> dtosList = [];

    for (var chiefOperation in fetchedChiefOperationsList) {
      final chiefOperationDto = ChiefOperationDto.fromMap(chiefOperation);
      dtosList.add(chiefOperationDto);
    }

    return _chiefOperationMapper.listFromDto(dtosList);
  }
}
