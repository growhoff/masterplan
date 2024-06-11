import 'package:master_plan/data/repositories/supabase/dto/position_staff_dto.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/staff.dart';

class PositionStaff {
  final int id;
  final int positionId;
  final Position position;
  final int userId;
  final Staff staff;

  PositionStaff(
      {required this.id,
      required this.positionId,
      required this.userId,
      required this.position,
      required this.staff});

  factory PositionStaff.fromDTO(PositionStaffDTO dto) {
    return PositionStaff(
        id: dto.id,
        positionId: dto.positionId,
        userId: dto.staffId,
        staff: Staff.fromDTO(dto.staff),
        position: Position(
            id: dto.position?.id ?? 0, name: dto.position?.name ?? ''));
  }
}
