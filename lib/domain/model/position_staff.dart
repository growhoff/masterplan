import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/staff.dart';
import 'package:master_plan/domain/model/unit.dart';

import 'area.dart';

class PositionStaffModel {
  final int id;
  final int positionId;
  final Position position;
  final int staffId;
  final Staff staff;
  final int? areaId;
  final Area? area;
  final int? unitId;
  final Unit? unit;

  PositionStaffModel(
      {required this.id,
      required this.positionId,
      required this.staffId,
      required this.position,
      required this.staff,
      this.areaId,
      this.area,
      this.unitId,
      this.unit});

  factory PositionStaffModel.fromDTO(PositionStaffDTO dto) {
    return PositionStaffModel(
        id: dto.id,
        positionId: dto.positionId,
        staffId: dto.staffId,
        staff: Staff.fromDTO(dto.staff),
        position: Position(id: dto.position.id, name: dto.position.name),
        areaId: dto.areaId,
        area: Area(
            id: dto.area?.id ?? 0,
            name: dto.area?.name ?? '',
            number: dto.area?.number ?? '',
            unitId: dto.area?.unitId ?? 0),
        unit: Unit(
            id: dto.unit?.id ?? 0,
            companyId: dto.unit?.companyId ?? 0,
            name: dto.unit?.name,
            number: dto.unit?.number),
        unitId: dto.unitId);
  }
}
