import 'package:master_plan/data/repositories/supabase/dto/position_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/data/repositories/supabase/impliments/imp_dto.dart';

import 'area_dto.dart';

class PositionStaffDTO extends Dto {
  final int id;
  final int positionId;
  final PositionDTO position;
  final int staffId;
  final StaffDTO staff;
  final int? areaId;
  final AreaDTO? area;

  PositionStaffDTO(
      {required this.id,
      required this.positionId,
      required this.staffId,
      required this.position,
      required this.staff,
       this.areaId,
       this.area});

  factory PositionStaffDTO.fromMap(Map<String, dynamic> map) {
    return PositionStaffDTO(
        id: map['id'],
        positionId: map['position_id'],
        staffId: map['staff_id'],
        position: PositionDTO.fromMap(map['z_position']),
        staff: StaffDTO.fromMap(map['z_staff']),
        areaId: map['area_id'],
        area: map['z_area'] != null ? AreaDTO.fromMap(map['z_area']) : null);
  }
}
