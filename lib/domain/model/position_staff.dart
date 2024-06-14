import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/staff.dart';

import 'area.dart';

class PositionStaffModel {
  final int id;
  final int positionId;
  final Position position;
  final int staffId;
  final Staff staff;
  final int? areaId;
  final Area? area;

  PositionStaffModel(
      {required this.id,
      required this.positionId,
      required this.staffId,
      required this.position,
      required this.staff,
      this.areaId,
      this.area});

  factory PositionStaffModel.fromDTO(PositionStaffDTO dto) {
    return PositionStaffModel(
        id: dto.id,
        positionId: dto.positionId,
        staffId: dto.staffId,
        staff: Staff.fromDTO(dto.staff),
        position:
            Position(id: dto.position.id, name: dto.position.name ),
        areaId: dto.areaId,
        area: Area(
            id: dto.area?.id ?? 0,
            name: dto.area?.name ?? '',
            number: dto.area?.number ?? '',
            unitId: dto.area?.unitId ?? 0));
  }
}
