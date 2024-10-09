import 'package:master_plan/data/repositories/supabase/dto/staff_dto.dart';
// import 'package:master_plan/data/repositories/supabase/dto/user_dto.dart';
import 'package:master_plan/domain/model/area.dart';
import 'package:master_plan/domain/model/company.dart';
import 'package:master_plan/domain/model/position.dart';
import 'package:master_plan/domain/model/unit.dart';

class User {
  final int id;
  final String fio;
  final int positionId;
  final int companyId;
  final Company company;
  final int? unitId;
  final int? areaId;
  final String? photo;
  final Position position;
  final Unit? unit;
  final Area? area;
  User({
    required this.id,
    required this.fio,
    required this.positionId,
    required this.companyId,
    required this.company,
    required this.unitId,
    required this.areaId,
    required this.photo,
    required this.position,
    this.unit,
    this.area,
  });

  static final empty = User(
    id: 0,
    fio: '',
    positionId: 0,
    companyId: 0,
    company: Company.empty,
    unitId: 0,
    areaId: 0,
    photo: '',
    position: Position.empty,
    unit: Unit.empty,
    area: Area.empty,
  );

  factory User.fromDTO(StaffDTO dto, Unit? unit, Area? area) {
    return User(
        id: dto.id,
        fio: dto.fio,
        positionId: dto.positionId,
        companyId: dto.companyId!,
        company: Company(id: dto.company!.id, name: dto.company!.name, code: dto.company!.code),
        unitId: unit?.id,
        areaId: area?.id,
        unit: unit,
        area: area,
        photo: dto.photo,
        position: Position(id: dto.position?.id ?? 0, name: dto.position?.name ?? ''));
  }
}
