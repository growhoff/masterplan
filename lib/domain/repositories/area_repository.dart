import 'package:master_plan/data/repositories/supabase/dto/area_dto.dart';


import '../../data/repositories/supabase/service/area_table.dart';
import '../mappers/area_mapper.dart';
import '../model/area.dart';

class AreaRepository{

  final _areaTable = AreaTable();

  final _areaMapper = AreaMapper();

  Future<List<Area>> getAreasListByUnitId({required int unitId})async{
    var fetchedUnitsList = await _areaTable.selectByUnitId(unitId: unitId);

    List<AreaDTO> dtosList = [];

    for (var area in fetchedUnitsList){
      final areaDto = AreaDTO.fromMap(area);
      dtosList.add(areaDto);
    }

    return _areaMapper.listFromDto(dtosList);
  }
}