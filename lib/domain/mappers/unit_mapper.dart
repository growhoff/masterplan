import 'package:master_plan/data/repositories/supabase/dto/unit_dto.dart';
import 'package:master_plan/domain/mappers/mapper.dart';
import 'package:master_plan/domain/model/unit.dart';

class UnitMapper extends Mapper<UnitDTO, Unit> {
  @override
  Unit fromDto(UnitDTO dto) {
    return Unit(
        id: dto.id,
        name: dto.name ?? '',
        number: dto.number ?? '',
        staffId: dto.staffId ?? 0,
        companyId: dto.companyId);
  }

  @override
  List<Unit> listFromDto(List<UnitDTO> dtosList) {
    List<Unit> unitsList = [];

    for (var dto in dtosList) {
      final unit = fromDto(dto);
      unitsList.add(unit);
    }

    return unitsList;
  }
}
