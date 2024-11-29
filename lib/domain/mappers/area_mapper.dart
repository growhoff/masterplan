import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/domain/mappers/mapper.dart';
import 'package:master_plan/domain/model/unit.dart';

import '../../data/repositories/supabase/dto/area_dto.dart';
import '../model/area.dart';

class AreaMapper extends Mapper<AreaDTO, Area> {
  @override
  Area fromDto(AreaDTO dto) {
    return Area(
      id: dto.id,
      name: dto.name,
      number: dto.number,
      unitId: dto.unitId,
    );
  }

  @override
  List<Area> listFromDto(List<AreaDTO> dtosList) {
    List<Area> areasList = [];

    for (var dto in dtosList) {
      final area = fromDto(dto);
      areasList.add(area);
    }

    return areasList;
  }
}
