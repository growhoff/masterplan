import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/staff.dart';

class PositionStaffModel {
  final int id;
  final int positionId;
  final Position position;
  final int staffId;
  final Staff staff;

  PositionStaffModel(
      {required this.id,
      required this.positionId,
      required this.staffId,
      required this.position,
      required this.staff});

  factory PositionStaffModel.fromDTO(PositionStaffDTO dto) {
    return PositionStaffModel(
        id: dto.id,
        positionId: dto.positionId,
        staffId: dto.staffId,
        staff: Staff.fromDTO(dto.staff),
        position: Position(
            id: dto.position?.id ?? 0, name: dto.position?.name ?? ''));
  }
}
