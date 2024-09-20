import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/data/repositories/supabase/service/unit_table.dart';
import 'package:master_plan/domain/mappers/unit_mapper.dart';

import '../model/unit.dart';

class UnitRepository {


  final _unitTable = UnitTable();

  final _unitMapper = UnitMapper();

  Future<List<Unit>> getUnitList(List<int> unitIdsList) async {
    var fetchedUnitsList = await _unitTable.selectByUnitsIdsList(unitIdsList);

    List<UnitDTO> dtosList = [];

    for (var unit in fetchedUnitsList) {
      final unitDto = UnitDTO.fromMap(unit);
      dtosList.add(unitDto);
    }

    return _unitMapper.listFromDto(dtosList);
  }
}
